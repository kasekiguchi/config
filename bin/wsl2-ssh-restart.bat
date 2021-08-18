@echo off
wsl -u root -- service ssh restart

rem ubuntuというディストリビューションを指定するときは下のコマンド。
rem wsl -d Ubuntu -u root -- service ssh restart