#!/usr/local/bin/powershell -File
# Caution : this file's encoding is Shift-JIS for powershell
# How to use
# install pdftk on wsl        : $> sudo apt update; sudo apt -y upgrade; sudo apt install pdftk
# copy this script to home    : $> cp ~/Documents/GitHub/config/bin/doc2pdf_meeting.ps1 /mnt/c/Users/kseki/
# make tmp folder on home     : PS> cd ~; mkdir tmp
# change directory to target  : PS> cd "C:\Users\kseki\OneDrive - �����s�s��w Tokyo City University\�@�V�X_��C2020\2020_������c"
# do script with password     : PS> PowerShell -ExecutionPolicy RemoteSigned ~\doc2pdf_meeting.ps1 . $oname $pass
# then doc files converts to pdf in tmp folder and generate the combined pdf named $oname with $pass in current folder


#Param([array]$files,$pass)
Param($folder,$oname,$pass)
$word = NEW-OBJECT -COMOBJECT WORD.APPLICATION
$folder
# docx�t�@�C���܂���doc�t�@�C������������
$files = Get-ChildItem $folder -Recurse| Where-Object{($_.Name -match "docx$" -or $_.Name -match "doc$") -and ($_.Name -like "*�c���^*")}
#$files = Get-ChildItem $folder | Where-Object{($_.Name -match "docx$" -or $_.Name -match "doc$")}
Write-Host "$files"

$cpath = pwd
cd ~
$homepath = pwd
cd $cpath

foreach($file in $files)
{   
   try 
   {
        
        if($pass)
        {
            $doc = $word.Documents.OpenNoRepairDialog($file.FullName,0,1,0,$pass,$pass)
        }else{
            $doc = $word.Documents.OpenNoRepairDialog($file.FullName)
        }
        # �g���q��pdf�ɕύX���ĕۑ�����
        $tname0=$homepath.Path + "\tmp\" + $file.Name.Replace($file.Extension,".pdf")
        $tname=$tname0.Replace(" ","_")
        $doc.SaveAs([ref] $tname,[ref] 17)        
        $t2name = $tname.Replace("C:","/mnt/c")
        $pdfs = @("$pdfs",$t2name.Replace("\","/"))
        Write-Host "$($file.FullName)��PDF�ϊ����܂���"
        $doc.Close(0)
    }
    catch
    {
        Write-Host "[ERROR]$($file.FullName)��PDF�ϊ��Ɏ��s���܂���"
    }
}

$word.Quit()
$pdfunitecmd = "wsl.exe /usr/bin/pdftk $pdfs cat output ./$oname user_pw $pass"
$pdfunitecmd
Invoke-Expression $pdfunitecmd
