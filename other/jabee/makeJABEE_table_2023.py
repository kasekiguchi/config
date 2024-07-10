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


class Student:
    def __init__(self, name, id, yomi, birth, lsSubject, req, lstKyoyo, lstTaiiku):
        self.name = name
        self.id = id
        self.yomi = yomi
        self.birth = birth
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
                    elif tb[ix] == u'○':
                        val = 1
                    else:
                        val = float(tb[ix])
                    sub.setMSE(ix - 3, val)


def checkJABEE(sub, val):
    sub.setJABEE(val)


def find_item(data, col, strng):
    # find strng data in data start from col
    # if find return the col, else return 0
    for i in range(col, len(data) - 1):
        if data[i] == strng:
            return i


def convertMSE2JABEE(lst):
    return np.array([[0.5, 0.5, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 0], [0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 1 / 2, 1 / 2, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 0], [0, 0, 0, 0, 0, 1 / 2, 0, 1 / 2, 0], [0, 0, 0, 0, 0, 0, 0, 0, 1]]).T @ lst.T


############################################
if __name__ == "__main__":

    with open('data.csv', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter=',')
        student_scores = list(lines)

    with open('table_2017.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2017 = list(lines)

    with open('table_2018.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2018 = list(lines)

    with open('table_2019.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2019 = list(lines)

    with open('table_2020.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2020 = list(lines)

    with open('table_2021.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2021 = list(lines)

    with open('table_2022.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2022 = list(lines)

    with open('table_2023.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2023 = list(lines)

    with open('table_2024.dat', 'r', encoding='utf8') as rfile:
        lines = csv.reader(rfile, delimiter='\t')
        table_2024 = list(lines)

    # listSubGroup_2019 = ["教養科目", "体育科目", "外国語科目", "工学基礎", "専門"]
    # listSubGroup_2020 = ["教養科目", "体育科目", "PBL", "外国語科目", "理工学基礎", "専門"]
    # listSubGroup_2021 = ["教養科目", "体育科目", "外国語科目", "理工学基礎", "専門"]

    listStudent = []

    for data in student_scores:
        id = data[17]  # 学籍番号
        name = data[18].replace(u'　', '')  # 氏名
        birth = data[19]
        yomi = data[20]
        GPA = data[21]

#        print(id, name, birth)

        year = id[0:2]

        if (not (year == '17' or year == '18' or year == '19' or year == '20')):  # 対象入学年度
            continue

        table = table_2018

        if (year == '17'):
            table = table_2017
        if (year == '18'):
            table = table_2018
        if (year == '19'):
            table = table_2019
        if (year == '20'):
            table = table_2020
        if (year == '21'):
            table = table_2021
        if (year == '22'):
            table = table_2022
        if (year == '23'):
            table = table_2023
        if (year == '24'):
            table = table_2024

        # JABEE達成のrequirement
        req = np.sum([[int(s.replace("", "0").replace("0◎0", "2").replace("0○0", "1"))
                       for s in row] for row in list(zip(*[row for row in table if row[2] == "○"]))[3:]], axis=1)
        lstKyoyo = [s[0] for s in table if "教養" in s[1]]
        lstTaiiku = [s[0] for s in table if "体育" in s[1]]

        # 学科基準からJABEE基準への変換式の登録
        if int(year) >= 23:  # 2023年度から基準更新
            mse2jabee = convertMSE2JABEE
        else:
            def mse2jabee(x): return x

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
                sub = Subject(strng.replace(u'　', ''), '20' + year)
                checkScore(sub, data[col + col2score])  # set sub.passed
                if sub.getPassed() == True:
                    sub.setGroup(sub_group)
                    sub.compulsory = comp
                    checkUnits(sub, data[col + col2unit])
                    checkTarget(sub, table)
                    checkJABEE(sub, mse2jabee(sub.getMSE()))
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

        student = Student(name, id, yomi, birth, listSubject,
                          req, lstKyoyo, lstTaiiku)
        listStudent.append(student)

    for std in listStudent:
        print(std.id, std.name, std.birth)
        dir = os.getcwd()

        wfile1 = dir + '/' + 'results/' + std.getID() + '_' + std.getName() + '.xlsx'
        writeExcel(wfile1, std)

        wfile2 = dir + '/' + 'pdfs/' + std.getID() + '_' + std.getName() + '.pdf'
        excel2pdf(wfile1, wfile2)
