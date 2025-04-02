; 基本的なホットストリング設定
Hotstring("::gia", "git add .")
Hotstring("::giac", "git commit -a -m " "{Left}")
Hotstring("::gibr", "git branch{Space}")
Hotstring("::gibrd", "git branch -d{Space}")
Hotstring("::gic", "git commit -m " "{Left}")
Hotstring("::gica", "git commit --amend -m " "{Left}")
Hotstring("::gican", "git commit --amend --no-edit")
Hotstring("::gico", "git checkout{Space}")
Hotstring("::gicob", "git checkout -b{Space}")
Hotstring("::gicon", "git config --global{Space}")
Hotstring("::gist", "git stash save --include-untracked " "{Left}")
Hotstring("::gistl", "git stash list")
Hotstring(":R:gistp", "git stash pop stash@{}")
Hotstring("::gists", "git stash show")
Hotstring("::gireb", "git rebase{Space}")
Hotstring("::girebi", "git rebase -i HEAD~")
Hotstring("::giref", "git reflog -7")
Hotstring("::giress", "git reset --soft HEAD")
Hotstring("::giresh", "git reset --hard HEAD")
Hotstring("::gil", "git log --oneline -5")
Hotstring("::gim", "git merge --no-ff{Space}")
Hotstring("::gis", "git status{Space}")

; 応用設定
Hotstring("::gishbr", "git show-branch | grep '*'")
Hotstring("::gigr",
  "git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'")

; Hugo用一時設定
Hotstring("::hsv", "hugo server --ignoreCache -D")