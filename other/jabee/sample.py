from docx import Document
from pathlib import Path
import re
# pip install python-docx
# python.exe sample.py
document = Document('./06.docx')
dest = open('table_2024.dat', 'w', encoding='UTF-8')
dest.write("科目名	科目群	必選	1	2	3	4	5	6	7	\n")
flag = 0
for i, t in enumerate(document.tables):
    for j, r in enumerate(t.rows):
        # if flag:
        if len(r.cells) == 9:
            if r.cells[1].text not in "授業科目":
                print(i, j, r.cells[1].text, r.cells[3].text)
                dest.write(r.cells[1].text + "	" + r.cells[0].text.replace("\n", "") + "	" + " " + "	" + r.cells[2].text + "	" + r.cells[3].text +
                           "	" + r.cells[4].text + "	" + r.cells[5].text + "	" + r.cells[6].text + "	" + r.cells[7].text + "	" + r.cells[8].text + "\n")

dest.close()
