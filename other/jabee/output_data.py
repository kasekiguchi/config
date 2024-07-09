import openpyxl
from openpyxl.styles import PatternFill, Border, Side, Alignment, Font
import win32com.client
import numpy as np


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
            sheet.cell(row=rowIndex, column=colIndex).value = str(colData).replace(
                "0.0", "")
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

    # 集計表 : zone : 左、右
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

        # table head
        col_ind = 6 + zone_index * 14
        sheet.cell(row=5, column=col_ind).value = u'学習・教育到達目標'
        col_alphabet1 = sheet.cell(row=5, column=col_ind).column_letter
        col_alphabet2 = sheet.cell(row=5, column=col_ind + 8).column_letter
        tmp_str = '{:}5:{:}5'.format(col_alphabet1, col_alphabet2)
        sheet.merge_cells(tmp_str)
        sheet.cell(row=5, column=col_ind).alignment = alignment
        sheet.cell(row=5, column=col_ind).font = bold
        sheet.cell(row=5, column=col_ind).fill = fillB
        # CSS設定
        for col in range(0, 9):
            sheet.cell(row=5, column=col_ind + col).border = border

    # 集計表CSS設定
    for zone_index in range(1, 2):
        col_ind1 = 2
        col_ind2 = 2 + zone_index * 14
        for col in range(0, 13):
            sheet.cell(row=6, column=col_ind2 +
                       col).value = str(sheet.cell(row=6, column=col_ind1 + col).value).replace("0.0", "")
            sheet.cell(row=6, column=col_ind2 + col).border = border
            sheet.cell(row=6, column=col_ind2 + col).font = bold
            sheet.cell(row=6, column=col_ind2 + col).fill = fillB
            sheet.cell(row=6, column=col_ind2 + col).alignment = alignment

    # JABEE集計表設定
    row_ind = 52
    col_ind = 19
    sheet.cell(row=row_ind + 0, column=col_ind).value = '項目'
    sheet.cell(row=row_ind + 1, column=col_ind).value = '要件'
    sheet.cell(row=row_ind + 2, column=col_ind).value = '習得'
    sheet.cell(row=row_ind + 3, column=col_ind).value = '不足'
    sheet.cell(row=row_ind + 4, column=col_ind).value = '判定'

    for ix in range(0, 5):  # JABEE集計表CSS設定
        sheet.cell(row=row_ind + ix, column=col_ind).border = border
        sheet.cell(row=row_ind + ix, column=col_ind).font = bold
        sheet.cell(row=row_ind + ix, column=col_ind).fill = fillB
        sheet.cell(row=row_ind + ix, column=col_ind).alignment = alignment

    summary = np.sum(np.array(list(zip(*tbl))[3:]), axis=1)
    for col in range(1, 10):  # JABEE集計
        alph1 = sheet.cell(row=6, column=5 + col).column_letter
        alph2 = sheet.cell(row=6, column=col_ind + col).column_letter

        sheet.cell(row=row_ind + 0, column=col_ind + col).value = col
        sheet.cell(row=row_ind + 1, column=col_ind +
                   col).value = student.requirement[col - 1]
        sheet.cell(row=row_ind + 2, column=col_ind +
                   col).value = summary[col - 1]
        sheet.cell(row=row_ind + 3, column=col_ind +
                   col).value = sheet.cell(row=row_ind + 1, column=col_ind + col).value - float(sheet.cell(row=row_ind + 2, column=col_ind + col).value)
        sheet.cell(row=row_ind + 4, column=col_ind +
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
