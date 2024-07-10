import csv
import shutil

if __name__ == "__main__":
    grade = ['1', '2', '3', '4']
    GRADE = ['１', '２', '３', '４']

    for i in grade:
        with open('grade_' + i + '_member.csv', 'r', encoding='shift-jis') as rfile:
            lines = csv.reader(rfile, delimiter=',')
            lst = list(lines)

        l = [[s[1], s[1].replace("g", "") + ".pdf"]
             for s in lst if s[2] == 'user']
        folder = './resutls/pdf/' + GRADE[int(i) - 1] + '年生'
        with open(folder + '/member_list.csv', 'w') as f:
            writer = csv.writer(f)
            writer.writerows(l)

        shutil.make_archive('eportfolio' + i + '.zip',
                            'zip', root_dir=folder)
