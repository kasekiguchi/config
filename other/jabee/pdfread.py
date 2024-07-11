from pdfminer.high_level import extract_text
from pathlib import Path

# PDFファイルからテキストを抽出
# source = Path('学修要覧2019_(機シ).pdf')
source = Path('2019.pdf')

# text = extract_text(source, pages=(8,10), codec='utf-8')
text = extract_text(source, codec='utf-8')
print(text)
