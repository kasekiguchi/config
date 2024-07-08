import csv
import numpy as np
import openpyxl
from openpyxl.styles import PatternFill, Border, Side, Alignment, Protection, Font
from openpyxl.formula.translate import Translator
import win32com.client
import PyPDF2
import re
import os


class Student:
    def __init__(self, name, id, yomi, birth, table, lsSubject):
        self.name = name
        self.id = id
        self.yomi = yomi
        self.birth = birth
        self.table = table

        self.lsSubject = lsSubject

        self.JABEE_sum1 = np.zeros(9)
        self.JABEE_sum2 = np.zeros(9)

        self.numKyoyo = 0
        self.numTaiiku = 0

        self.check()

    def getID(self):
        return self.id

    def getName(self):
        return self.name

    def getBirth(self):
        return self.birth

    def getJABEE_sum1(self):
        return self.JABEE_sum1

    def getJABEE_sum2(self):
        return self.JABEE_sum2

    def getTable(self):
        return self.table

    def getSubjects(self):
        return self.lsSubject

    def getNumKyoyo(self):
        return self.numKyoyo

    def getNumTaiiku(self):
        return self.numTaiiku

    def check(self):
        unitsKyoyo = 0
        unitsTaiiku = 0

        for sub in self.lsSubject:
            if sub.getEnable() and sub.getPassed():
                if sub.getKyoyo() == True:
                    unitsKyoyo += sub.getUnits()

                elif sub.getTaiiku() == True:
                    unitsTaiiku += sub.getUnits()

                else:
                    for jj in range(0, 9):
                        jab = sub.getJABEE(jj)
                        if jab == 1:
                            self.JABEE_sum1[jj] += 1
                        elif jab == 2:
                            self.JABEE_sum2[jj] += 1

        self.numKyoyo = int(min(unitsKyoyo / 2, 5))
        self.JABEE_sum1[0] += self.numKyoyo
        self.JABEE_sum2[1] += self.numKyoyo

        self.numTaiiku = int(unitsTaiiku)
        self.JABEE_sum2[0] += self.numTaiiku


class Subject:
    def __init__(self, name):
        self.name = name
        self.swKyoyo = False
        self.swTaiiku = False
        self.units = 0
        self.enable = False
        self.passed = False
        self.score = 0
        self.JABEE = np.zeros(9)

    def getName(self):
        return self.name

    def getEnable(self):
        return self.enable

    def setEnable(self):
        self.enable = True

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

    def setJABEE(self, col, val):
        self.JABEE[col] = val

    def getJABEE(self, col):
        return self.JABEE[col]

    def getJABEE_list(self):
        return self.JABEE

# 教養科目の科目名リスト取得


def getKyoyoList(data, st):
    listKyoyo = []
    col = st
    while col < 1095:  # 1061
        str = data[col]
        if str == u'■体育科目・必修■' or str == u'■体育科目・選択必修■':    # 2024.3.14 updated
            break

        subject = Subject(str.replace(u'　', ''))
        if str[0] != u'■':
            subject.setEnable()

        subject.setKyoyo()
        listKyoyo.append(subject)

        col += 1
    return listKyoyo, col

# 体育科目の科目名リスト取得


def getTaiikuList(data, st):
    listTaiiku = []
    col = st
    while col < 1095:  # 1061
        str = data[col]
        if str == u'■外国語科目・必修■':
            break

        subject = Subject(str.replace(u'　', ''))
        if str[0] != u'■':
            subject.setEnable()

        subject.setTaiiku()
        listTaiiku.append(subject)

        col += 1
    return listTaiiku, col

# 英語科目の科目名リスト取得


def getEnglishList(data, st):
    ls = []
    col = st
    while col < 1095:  # 1061
        str = data[col]
        if str == u'■工学基礎・必修■' or str == u'■理工学基礎・必修■':  # 2024.3.14 updated
            break

        subject = Subject(str.replace(u'　', ''))
        if str[0] != u'■':
            subject.setEnable()

        ls.append(subject)

        col += 1
    return ls, col

# 工学基礎科目の科目名リスト取得


def getBasicEngList(data, st):
    ls = []
    col = st
    while col < 1095:  # 1061
        str = data[col]
        if str == u'■専門・必修■':
            break

        subject = Subject(str.replace(u'　', ''))
        if str[0] != u'■':
            subject.setEnable()

        ls.append(subject)

        col += 1
    return ls, col

# 専門科目の科目名リスト取得


def getSpecialList(data, st):
    ls = []
    col = st
    while col < 1095:  # 1061
        str = data[col]
        if str == '':
            break

        subject = Subject(str.replace(u'　', ''))
        if str[0] != u'■':
            subject.setEnable()

        ls.append(subject)

        col += 1
    return ls, col


def getScore(str):
    if str == u'秀':
        score = 4
    elif str == u'優':
        score = 3
    elif str == u'良':
        score = 2
    elif str == u'可':
        score = 1
    elif str == u'認定':
        score = 9
    else:
        score = 0

    return score


def checkUnits(data, sub, col):
    str = data[col]
    col += 1
    if sub.getEnable() == True:
        units = float(str)   # 0.5単位に対応 2024.3.14
        sub.setUnits(units)
    return col


def checkScore(data, sub, col):
    str = data[col]
    col += 1
    if sub.getEnable() == True:
        score = getScore(str)
        sub.setScore(score)
    return col


def checkJABEE(sub, table):
    name = sub.getName()

    sum = 0

    ix = 0
    for tb in table:
        if ix == 0:
            ix += 1
            continue

        if (tb[0] == name):
            for ix in range(3, 12):
                if tb[ix] == u'◎':
                    sub.setJABEE(ix - 3, 2)
                    sum += 1
                elif tb[ix] == u'○':
                    sub.setJABEE(ix - 3, 1)
                    sum += 1
    return sum


def writeExcel(wfile, student):
    wb = openpyxl.Workbook()
    sheet = wb.active
    sheet.title = u'学習・教育到達目標の達成状況'

    tbl = student.getTable()

    side = Side(style='thin', color='000000')
    border = Border(top=side, left=side, bottom=side, right=side)
    alignment = Alignment(horizontal='center', vertical='center',
                          text_rotation=0, wrap_text=False, shrink_to_fit=False, indent=0)
    fillB = PatternFill(patternType='solid', fgColor='d9d9d9')
    fillG = PatternFill(patternType='solid', fgColor='ebf1de')
    fillR = PatternFill(patternType='solid', fgColor='fde9d9')
    fillY = PatternFill(patternType='solid', fgColor='fefcd8')
    fillBlue = PatternFill(patternType='solid', fgColor='eeeeff')
    bold = Font(bold=True)

    sheet.cell(row=2, column=1).value = '学籍番号'
    sheet.cell(row=2, column=2).value = student.getID()
    sheet.cell(row=3, column=1).value = '氏名'
    sheet.cell(row=3, column=2).value = student.getName()
    sheet.cell(row=4, column=1).value = '生年月日'
    yy = student.getBirth()[0:4]
    mm = student.getBirth()[4:6]
    dd = student.getBirth()[6:8]

    sheet.cell(row=4, column=2).value = yy + '年' + mm + '月' + dd + '日'

    for rowIndex in range(2, 5):
        sheet.cell(row=rowIndex, column=1).font = bold
        sheet.cell(row=rowIndex, column=1).border = border
        sheet.cell(row=rowIndex, column=2).border = border
        sheet.cell(row=rowIndex, column=1).alignment = alignment
        sheet.cell(row=rowIndex, column=2).alignment = alignment

    sheet.column_dimensions['B'].width = 13
    sheet.column_dimensions['C'].width = 10

    zone_index = 0
    rowIndex = 6
    for rowData in tbl:
        colIndex = 2 + zone_index * 14
        for colData in rowData:
            sheet.cell(row=rowIndex, column=colIndex).value = colData
            sheet.cell(row=rowIndex, column=colIndex).border = border
            sheet.cell(row=rowIndex, column=colIndex).alignment = alignment
            if rowIndex == 6:
                sheet.cell(row=rowIndex, column=colIndex).fill = fillB
                sheet.cell(row=rowIndex, column=colIndex).font = bold

            if colIndex == 4 + zone_index * 14:
                colIndex += 2
            else:
                colIndex += 1

        rowIndex += 1
        if rowIndex > 56:
            zone_index += 1
            rowIndex = 7

    numKyoyo = student.getNumKyoyo()
    numTaiiku = student.getNumTaiiku()
    checkedK = 0
    checkedT = 0
    rowIndex = 6
    zone_index = 0

    for rowData in tbl:
        colIndex = 5 + zone_index * 14
        if rowIndex == 6:
            sheet.cell(row=rowIndex, column=colIndex).value = u'習得'
            sheet.cell(row=rowIndex, column=colIndex).border = border
            sheet.cell(row=rowIndex, column=colIndex).alignment = alignment
            sheet.cell(row=rowIndex, column=colIndex).fill = fillB
            sheet.cell(row=rowIndex, column=colIndex).font = bold
            rowIndex += 1
            continue

        if rowData[1] == u'教養':
            if checkedK < numKyoyo:
                sheet.cell(row=rowIndex, column=colIndex).value = u'☑'
                sheet.cell(row=rowIndex, column=colIndex).border = border
                sheet.cell(row=rowIndex, column=colIndex).alignment = alignment
                sheet.cell(row=rowIndex, column=colIndex).fill = fillG
                checkedK += 1

        elif rowData[1] == u'体育':
            if checkedT < numTaiiku:
                sheet.cell(row=rowIndex, column=colIndex).value = u'☑'
                sheet.cell(row=rowIndex, column=colIndex).border = border
                sheet.cell(row=rowIndex, column=colIndex).alignment = alignment
                sheet.cell(row=rowIndex, column=colIndex).fill = fillG
                checkedT += 1

        else:
            sub_name = rowData[0]
            sheet.cell(row=rowIndex, column=colIndex).border = border
            sheet.cell(row=rowIndex, column=colIndex).alignment = alignment
            for sub in student.getSubjects():
                if (sub_name == sub.getName()):
                    sheet.cell(row=rowIndex, column=colIndex).fill = fillG
                    if (sub.getEnable() and sub.getPassed()):
                        sheet.cell(row=rowIndex, column=colIndex).value = u'☑'

        rowIndex += 1
        if rowIndex > 56:
            zone_index += 1
            rowIndex = 7

    max_length = 0

    rowIndex = 6
    zone_index = 0
    for rowData in tbl:
        colIndex = 2 + zone_index * 14
        cell = sheet.cell(row=rowIndex, column=colIndex)
        if len(str(cell.value)) > max_length:
            max_length = len(str(cell.value))
        rowIndex += 1
        if rowIndex > 56:
            zone_index += 1
            rowIndex = 7

    adjusted_width = (max_length + 2) * 1.2

    for zone_index in range(0, 2):
        col_ind1 = 2 + zone_index * 14
        col_ind2 = 4 + zone_index * 14
        col_ind3 = 5 + zone_index * 14
        col_alphabet1 = sheet.cell(row=5, column=col_ind1).column_letter
        col_alphabet2 = sheet.cell(row=5, column=col_ind2).column_letter
        col_alphabet3 = sheet.cell(row=5, column=col_ind3).column_letter
        sheet.column_dimensions[col_alphabet1].width = adjusted_width
        sheet.column_dimensions[col_alphabet2].width = 5.5
        sheet.column_dimensions[col_alphabet3].width = 5.5

        for col in range(0, 9):
            col_ind = 6 + col + zone_index * 14
            col_alphabet = sheet.cell(row=5, column=col_ind).column_letter
            sheet.column_dimensions[col_alphabet].width = 5.2

        col_alphabet = sheet.cell(row=5, column=col_ind + 1).column_letter
        sheet.column_dimensions[col_alphabet].width = 1

        col_ind = 6 + zone_index * 14
        sheet.cell(row=5, column=col_ind).value = u'学習・教育到達目標'
        col_alphabet1 = sheet.cell(row=5, column=col_ind).column_letter
        col_alphabet2 = sheet.cell(row=5, column=col_ind + 8).column_letter
        tmp_str = '{:}5:{:}5'.format(col_alphabet1, col_alphabet2)
        sheet.merge_cells(tmp_str)
        sheet.cell(row=5, column=col_ind).alignment = alignment
        sheet.cell(row=5, column=col_ind).font = bold
        sheet.cell(row=5, column=col_ind).fill = fillB

        for col in range(0, 9):
            sheet.cell(row=5, column=col_ind + col).border = border

    for zone_index in range(1, 2):
        col_ind1 = 2
        col_ind2 = 2 + zone_index * 14
        for col in range(0, 13):
            sheet.cell(row=6, column=col_ind2 +
                       col).value = sheet.cell(row=6, column=col_ind1 + col).value
            sheet.cell(row=6, column=col_ind2 + col).border = border
            sheet.cell(row=6, column=col_ind2 + col).font = bold
            sheet.cell(row=6, column=col_ind2 + col).fill = fillB
            sheet.cell(row=6, column=col_ind2 + col).alignment = alignment

    row_ind = 53
    col_ind = 19
    sheet.cell(row=row_ind + 0, column=col_ind).value = '項目'
    sheet.cell(row=row_ind + 1, column=col_ind).value = '要件'
    sheet.cell(row=row_ind + 2, column=col_ind).value = '習得'
    sheet.cell(row=row_ind + 3, column=col_ind).value = '判定'
    for ix in range(0, 4):
        sheet.cell(row=row_ind + ix, column=col_ind).border = border
        sheet.cell(row=row_ind + ix, column=col_ind).font = bold
        sheet.cell(row=row_ind + ix, column=col_ind).fill = fillB
        sheet.cell(row=row_ind + ix, column=col_ind).alignment = alignment

    for col in range(1, 10):
        alph1 = sheet.cell(row=6, column=5 + col).column_letter
        alph2 = sheet.cell(row=6, column=col_ind + col).column_letter

        sheet.cell(row=row_ind + 0, column=col_ind + col).value = col
        sheet.cell(row=row_ind + 1, column=col_ind +
                   col).value = f'=COUNTIFS($D$7:$D$56,"○", {alph1}$7:{alph1}$56, "◎") + COUNTIFS($R$7:$R$52,"○", {alph2}$7:{alph2}$52, "◎")'
        sheet.cell(row=row_ind + 2, column=col_ind +
                   col).value = f'=COUNTIFS($D$7:$D$56,"○", $E7:$E56,"☑", {alph1}$7:{alph1}$56, "◎") + COUNTIFS($R$7:$R$52,"○", $S7:$S52,"☑", {alph2}$7:{alph2}$52, "◎")'
        sheet.cell(row=row_ind + 3, column=col_ind +
                   col).value = f'=IF({alph2}55 >= {alph2}54, "達成", "未達")'
        for ix in range(0, 4):
            sheet.cell(row=row_ind + 0, column=col_ind + col).font = bold
            sheet.cell(row=row_ind + 0, column=col_ind + col).fill = fillB
            sheet.cell(row=row_ind + ix, column=col_ind + col).border = border
            sheet.cell(row=row_ind + ix, column=col_ind +
                       col).alignment = alignment

        sheet.cell(row=row_ind + 3, column=col_ind + col).font = bold
        sheet.cell(row=row_ind + 3, column=col_ind + col).fill = fillY

    for row in sheet:
        for cell in row:
            sheet[cell.coordinate].font = Font(name='BIZ UDPゴシック')

    sheet.cell(row=1, column=1).value = "JABEEの学習・教育到達目標の達成状況表"
    sheet.cell(row=1, column=1).font = Font(size=24, bold=True)
    sheet.merge_cells('A1:AB1')
    sheet.cell(row=1, column=1).alignment = alignment
    sheet.cell(row=1, column=1).fill = fillBlue

    sheet.page_setup.orientation = 'landscape'
    sheet.page_setup.fitToWidth = 1
    sheet.sheet_properties.pageSetUpPr.fitToPage = True

    sheet.cell(row=2, column=25).value = '2024年3月19日'

    sheet.print_area = 'A1:AB56'

    sheet.page_setup.centerHorizontally = True
    sheet.page_setup.centerVertically = True

    sheet.page_margins.left = 0.4
    sheet.page_margins.right = 0.4
    sheet.page_margins.top = 0.4
    sheet.page_margins.bottom = 0.4
    sheet.page_margins.header = 0
    sheet.page_margins.footer = 0

    wb.save(wfile)
    wb.close()


def excel2pdf(input_file, output_file):
    # エクセルを開く
    app = win32com.client.Dispatch("Excel.Application")
    app.Visible = True
    app.DisplayAlerts = False
    # Excelでワークブックを読み込む
    book = app.Workbooks.Open(input_file)
    # PDF形式で保存
    xlTypePDF = 0
    book.ExportAsFixedFormat(xlTypePDF, output_file)
    # エクセルを閉じる
    app.Quit()


def find_item(data, col, str):
    # find str data in data start from col
    # if find return the col, else return 0
    for i in range(col,len(data)-1):
        if data[i] == str:
            return i


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

    listStudent = []
    col_head = 41  # position of "■教養科目・選択■"

■教養科目・選択■
■体育科目・必修■
■外国語科目・必修■
■外国語科目・選択（英語）■
■工学基礎・必修■
■工学基礎・選択■
■専門・必修■
■専門・選択必修■
■専門・学科基礎選択必修■
■専門・実験実習選択必修■
■専門・研究室指定選択必修■
■専門・選択■

    for data in student_scores:
        col = col_head  # "科目" の最初の列

        listKyoyo, col = getKyoyoList(data, col)
        listTaiiku, col = getTaiikuList(data, col)
        listEnglish, col = getEnglishList(data, col)
        listEngBase, col = getBasicEngList(data, col)
        listSpecial, col = getSpecialList(data, col)

        max_cols = max(max_cols, col)

    print('max_cols', max_cols)  # 139

    col1 = 200
    col2 = 41 + (col1 - 41) * 2   # 357

    for data in student_scores:
        id = data[17] # 学籍番号
        name = data[18].replace(u'　', '') # 氏名
        birth = data[19] # 
        yomi = data[20] # 
        GPA = data[21] # 

        print(id, name, birth)

        year = id[0:2]

        if (not (year == '17' or year == '18' or year == '19' or year == '20')):
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

        col = 41  # "科目" の最初の列

        listKyoyo, col = getKyoyoList(data, col)
        listTaiiku, col = getTaiikuList(data, col)
        listEnglish, col = getEnglishList(data, col)
        listEngBase, col = getBasicEngList(data, col)
        listSpecial, col = getSpecialList(data, col)

        listSubject = []

        col1 = 200
        col2 = 41 + (col1 - 41) * 2   # 357

#        for ii in range (0, 300):
#            print (ii, data[ii])
#        exit()

        for sub in listKyoyo:
            col1 = checkUnits(data, sub, col1)
            col2 = checkScore(data, sub, col2)
            sub.setKyoyo()
            sub.JABEE[0] = 2
            sub.JABEE[1] = 1

            if sub.getPassed() == True:
                listSubject.append(sub)

        for sub in listTaiiku:
            col1 = checkUnits(data, sub, col1)
            col2 = checkScore(data, sub, col2)
            sub.setTaiiku()
            sub.JABEE[0] = 2

            if sub.getPassed() == True:
                listSubject.append(sub)

        for sub in listEnglish:
            col1 = checkUnits(data, sub, col1)
            col2 = checkScore(data, sub, col2)

            if sub.getPassed() == True:
                listSubject.append(sub)

        for sub in listEngBase:
            col1 = checkUnits(data, sub, col1)
            col2 = checkScore(data, sub, col2)

            if sub.getPassed() == True:
                listSubject.append(sub)

        for sub in listSpecial:
            col1 = checkUnits(data, sub, col1)
            col2 = checkScore(data, sub, col2)

            if sub.getPassed() == True:
                listSubject.append(sub)

        for sub in listSubject:
            num = checkJABEE(sub, table)

        student = Student(name, id, yomi, birth, table, listSubject)
        listStudent.append(student)

    for std in listStudent:
        dir = os.getcwd()

        wfile1 = dir + '/' + 'results/' + std.getID() + '_' + std.getName() + '.xlsx'
        writeExcel(wfile1, std)

#        wfile2 = dir + '/' +  'results/' + std.getID() + '_' +  std.getName() + '.pdf'
#        excel2pdf(wfile1, wfile2)
