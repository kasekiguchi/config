import csv
import numpy as np
import openpyxl
from openpyxl.styles import PatternFill, Border, Side, Alignment, Protection, Font
from openpyxl.formula.translate import Translator
import win32com.client
import PyPDF2
import re
import os
from output_data import writeExcel, excel2pdf
import sys


class Student:
    def __init__(self, name, id, yomi, birth, grade, lsSubject, req, lstKyoyo, lstTaiiku):
        self.name = name
        self.id = id
        self.yomi = yomi
        self.birth = birth
        self.grade = grade
        self.requirement = req  # requirement
        self.lstKyoyo = lstKyoyo
        self.lstTaiiku = lstTaiiku
        self.table = [["科目名", "科目群", "必選"] + list(range(1, 10))]

        self.lsSubject = lsSubject

        self.check()

    def getID(self):
        return self.id

    def getName(self):
        return self.name

    def getBirth(self):
        return self.birth

    def getTable(self):
        return self.table

    def getSubjects(self):
        return self.lsSubject

    def check(self):
        countKyoyo = 0
        countTaiiku = 0

        for sub in self.lsSubject:
            if sub.getPassed():
                if sub.group == "教養科目":
                    if countKyoyo < len(self.lstKyoyo):
                        sub.name = self.lstKyoyo[countKyoyo]
                        countKyoyo += 1
                    else:
                        continue

                if sub.group == "体育科目":
                    if countTaiiku < len(self.lstTaiiku):
                        sub.name = self.lstTaiiku[countTaiiku]
                        countTaiiku += 1
                    else:
                        continue

                self.table.append(
                    [sub.name, sub.group, sub.compulsory] + sub.getJABEE().tolist())


class Subject:
    def __init__(self, name, year):
        self.name = name
        self.swKyoyo = False
        self.swTaiiku = False
        self.units = 0
        self.passed = False
        self.score = 0
        self.JABEE = np.zeros(9)
        self.year = year
        if int(year) >= 2023:
            self.MSE = np.zeros(7)
        else:
            self.MSE = np.zeros(9)
        self.group = ""
        self.compulsory = ""

    def setGroup(self, val):
        self.group = val

    def getName(self):
        return self.name

    def getPassed(self):
        return self.passed

    def setPassed(self):
        self.passed = True

    def getKyoyo(self):
        return self.swKyoyo

    def getTaiiku(self):
        return self.swTaiiku

    def setKyoyo(self):
        self.swKyoyo = True

    def setTaiiku(self):
        self.swTaiiku = True

    def setUnits(self, val):
        self.units = val

    def getUnits(self):
        return self.units

    def setScore(self, score):
        self.score = score
        if score >= 1:
            self.setPassed()

    def getScore(self):
        return self.score

    def setJABEE(self, val):
        self.JABEE = val

    def setMSE(self, col, val):
        self.MSE[col] = val

    def getMSE(self):
        return self.MSE

    def getJABEE(self):
        return self.JABEE


def getScore(strng):
    if strng == u'秀':
        score = 4
    elif strng == u'優':
        score = 3
    elif strng == u'良':
        score = 2
    elif strng == u'可':
        score = 1
    elif strng == u'認定':
        score = 9
    else:
        score = 0

    return score


def checkUnits(sub, strng):
    units = float(strng)   # 0.5単位に対応 2024.3.14
    sub.setUnits(units)


def checkScore(sub, strng):
    score = getScore(strng)
    sub.setScore(score)


def checkTarget(sub, table):
    name = sub.getName()
    for tb in table:
        if (tb[0] == name) or ("教養" in tb[1] and "教養" in sub.group) or ("体育" in tb[1] and "体育" in sub.group):
            for ix in range(3, 3 + len(sub.MSE)):
                if tb[ix] != u'':
                    if tb[ix] == u'◎':
                        val = 2
                    elif tb[ix] in '○◯〇':
                        val = 1
                    else:
                        val = float(tb[ix])
                    sub.setMSE(ix - 3, val)


def checkJABEE(sub, year):
    sub.setJABEE(mse2jabee(sub.getMSE(), year))


def find_item(data, col, strng):
    # find strng data in data start from col
    # if find return the col, else return 0
    for i in range(col, len(data) - 1):
        if data[i] == strng:
            return i


def mse2jabee(lst, year):
    if year >= 2023:
        return np.array([[0.5, 0.5, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 0], [0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 1 / 2, 1 / 2, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 0], [0, 0, 0, 0, 0, 1 / 2, 0, 1 / 2, 0], [0, 0, 0, 0, 0, 0, 0, 0, 1]]).T @ lst.T
    else:
        return lst


def gen_req(table, year):
    lst = np.array([])

    for row in list(zip(*[row for row in table if row[2] == "○"]))[3:]:
        tmp = []
        for s in row:
            if "◎" in s:
                tmp.append(2)
            elif "○" in s or "◯" in s or "〇" in s:
                tmp.append(1)
            elif not re.sub('\s*', '', s):
                tmp.append(0)
            else:
                tmp.append(float(s.replace('✓', '')))
        lst = np.append(lst, np.sum(tmp))
    return mse2jabee(lst, year)

    # return np.sum([[int(re.sub('0*[○◯〇]0*', '1', re.sub('0*[◎]0*', '2', re.sub('\s*', '0', s))))
    #                 for s in row] for row in list(zip(*[row for row in table if row[2] == "○"]))[3:]], axis=1)


############################################
if __name__ == "__main__":
    if len(sys.argv) > 1:
        with open(sys.argv[1], 'r', encoding='utf8') as rfile:
            lines = csv.reader(rfile, delimiter=',')
            student_scores = list(lines)
    else:
        with open('20240710.csv', 'r', encoding='utf8') as rfile:
            lines = csv.reader(rfile, delimiter=',')
            student_scores = list(lines)
    print(len(student_scores))

    with open('table_2017.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2017 = list(lines)
    req_2017 = gen_req(table_2017, 2017)

    with open('table_2018.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2018 = list(lines)
    req_2018 = gen_req(table_2018, 2018)

    with open('table_2019.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2019 = list(lines)
    req_2019 = gen_req(table_2019, 2019)

    with open('table_2020.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2020 = list(lines)
    req_2020 = gen_req(table_2020, 2020)

    with open('table_2021.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2021 = list(lines)
    req_2021 = gen_req(table_2021, 2021)

    with open('table_2022.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2022 = list(lines)
    req_2022 = gen_req(table_2022, 2022)

    with open('table_2023.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2023 = list(lines)
    req_2023 = gen_req(table_2023, 2023)

    with open('table_2024.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2024 = list(lines)
    req_2024 = gen_req(table_2024, 2024)

    listStudent = []

    for data in student_scores:
        id = data[17]  # 学籍番号
        name = data[18].replace(u'　', '')  # 氏名
        birth = data[19]
        yomi = data[20]
        GPA = data[21]
        grade = data[23]

        year = int('20' + id[0:2])

        table = eval("table_" + str(year))
        req = eval("req_" + str(year))

        # JABEE達成のrequirement
        lstKyoyo = [s[0] for s in table if "教養" in s[1]]
        lstTaiiku = [s[0] for s in table if "体育" in s[1]]

        c1 = find_item(data, 1, "科目")
        c2 = find_item(data, 1, "単位")
        c3 = find_item(data, 1, "評価")
        if c2 - c1 != c3 - c2:
            print("Error : check the length")
        col2unit = c2 - c1
        col2score = c3 - c1
        col = c1 + 3
        listSubject = []
        sub_group = ""  # 科目群
        comp = ""  # 必修・選択
        while 1:
            strng = data[col]
            if strng == u'' or strng == u'単位' or strng == u'以下余白':  # 修了条件
                break

            if strng[0] != u'■':
                sub = Subject(strng.replace(u'　', ''), str(year))
                checkScore(sub, data[col + col2score])  # set sub.passed
                if sub.getPassed() == True:
                    sub.setGroup(sub_group)
                    sub.compulsory = comp
                    checkUnits(sub, data[col + col2unit])
                    checkTarget(sub, table)
                    checkJABEE(sub, year)
                    listSubject.append(sub)
            else:
                sub_group = re.findall('■(.*)・', strng)[0]
                if "必修" in strng:
                    comp = "○"
                elif "選択" in strng:
                    comp = "△"
                else:
                    comp = ""
            col += 1

        student = Student(name, id, yomi, birth, grade, listSubject,
                          req, lstKyoyo, lstTaiiku)
        listStudent.append(student)
        print(len(listStudent))
    print(len(listStudent))

    for std in listStudent:
        print(std.id, std.name, std.birth)
        dir = os.getcwd()

        wfile1 = dir + '/results/xlsx/' + std.grade + "/" + \
            std.getID() + '_' + std.getName() + '.xlsx'
        writeExcel(wfile1, std)

        # wfile2 = dir + '/results/pdf/' + std.grade + "/"  + std.getID() + '_' + std.getName() + '.pdf'
        # excel2pdf(wfile1, wfile2)
