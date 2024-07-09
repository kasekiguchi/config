from docx import Document
from pathlib import Path
import re
import sys

# pip install python-docx
# python.exe gen_docx2dat.py 年度
args = sys.argv
document = Document('./' + args[1] + '.docx')
dest = open('table_' + args[1] + '.dat', 'w', encoding='UTF-8')
if int(args[1]) >= 2023:
    dest.write("科目名	科目群	必選	1	2	3	4	5	6	7	\n")
else:
    dest.write("科目名	科目群	必選	1	2	3	4	5	6	7	8	9	\n")

listGroup = "教養科目, 外国語科目, 体育科目, 理工学基礎科目, PBL科目"

flag = 0
for i, t in enumerate(document.tables):
    for j, r in enumerate(t.rows):
        if r.cells[0].text.replace("\n", "") in listGroup:
            group = listGroup
        else:
            group = "専門科目"
        if int(args[1]) >= 2023:
            if len(r.cells) == 9:
                if r.cells[1].text not in "授業科目":
                    print(i, j, r.cells[1].text, r.cells[3].text)
                    dest.write(r.cells[1].text + "	" + group + "	" + " " + "	" + r.cells[2].text + "	" + r.cells[3].text +
                               "	" + r.cells[4].text + "	" + r.cells[5].text + "	" + r.cells[6].text + "	" + r.cells[7].text + "	" + r.cells[8].text + "\n")
        else:
            if len(r.cells) == 11:
                if r.cells[1].text not in "授業科目":
                    print(i, j, r.cells[1].text, r.cells[3].text)
                    dest.write(r.cells[1].text + "	" + group + "	" + " " + "	" + r.cells[2].text + "	" + r.cells[3].text +
                               "	" + r.cells[4].text + "	" + r.cells[5].text + "	" + r.cells[6].text + "	" + r.cells[7].text + "	" + r.cells[8].text + r.cells[9].text + "	" + r.cells[10].text + "\n")

dest.close()
