
## vimで開く
alias vi='/usr/bin/vim'

# config home
set -U CHOME /Users/sekiguchi/Documents/GitHub/config
#set -x $CHOME/Setting/fish/myExport.fish

set -U fish_user_paths $CHOME/bin $fish_user_paths
set -U fish_user_paths /usr/local/bin $fish_user_paths
#set -U fish_user_paths $HOME/.rbenv/versions/2.5.0/bin $fish_user_paths

set -U TEXINPUTS "$DHOME/texExtension//:/usr/local/texlive/texmf-local"

#set -U MANPATH "/usr/local/texlive/2019/texmf-dist/doc/man"
#set -U INFOPATH "/usr/local/texlive/2019/texmf-dist/doc/info"
#set -U fish_user_paths "/usr/local/texlive/2019/bin/x86_64-linux" $fish_user_paths

## for windows explorer (required win10 creators update)
alias open='explorer.exe'
alias e='explorer.exe .'

function cd
builtin cd $argv
ls -a
end

# lsの色を見やすく変更
#if test ! -e ~/.dircolors/dircolors.ansi-dark
#git clone https://github.com/seebi/dircolors-solarized.git ~/.dircolors
#end
#eval (dircolors -c ~/.dircolors/dircolors.ansi-dark)

# aliases for git
alias g="git"
alias gd="git diff"
alias ga="git add"
alias gca="git commit -a -m"
alias gcm="git commit -m"
alias gbd="git branch -D"
alias gp="git push"
alias gb="git branch"
alias gcob="git checkout -b"
alias gco="git checkout"
alias gba="git branch -a"
alias glog="git log --graph --date=iso --pretty='[%ad]%C(auto) %h%d %Cgreen%an%Creset : %s'"
alias gll="git log --pretty=format:'%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]' --decorate --numstat"


alias x='exit'

# 一覧の上を最新として、境目をボーダーに
set -x FZF_DEFAULT_OPTS "--reverse --border"
# ディレクトリ検索で選択した項目の配下の構成をプレビューに表示する
set -x FZF_ALT_C_OPTS   "--preview 'tree -C {} | head -200'"
# ファイル検索で選択した項目の中身をプレビューに表示する
set -x FZF_CTRL_T_OPTS  "--preview 'head -100 {}'"

# エラーコードは番号で表示する
set -g theme_show_exit_status yes
# Gitのahead情報を細かく表示する
set -g theme_display_git_ahead_verbose yes

# for docker 
set -x DOCKER_HOST 'tcp://0.0.0.0:2375'

set -U ODHOME ~/OneDrive\ -\ tcu.ac.jp
#set -U XDG_CONFIG_HOME $CHOME/bin/fish
#set -U DISPLAY 192.168.128.1:0.0
