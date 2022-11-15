#!/usr/local/bin/powershell -File
# Caution : this file's encoding is Shift-JIS for powershell
# How to use
# install pdftk on wsl        : $> sudo apt update; sudo apt -y upgrade; sudo apt install pdftk
# copy this script to home    : $> cp ~/Documents/GitHub/config/bin/doc2pdf_meeting.ps1 /mnt/c/Users/kseki/
# make tmp folder on home     : PS> cd ~; mkdir tmp
# change directory to target  : PS> cd "C:\Users\kseki\OneDrive - 東京都市大学 Tokyo City University\機シス_主任2020\2020_教室会議"
# do script with password     : PS> PowerShell -ExecutionPolicy RemoteSigned ~\doc2pdf_meeting.ps1 . $oname $pass
# then doc files converts to pdf in tmp folder and generate the combined pdf named $oname with $pass in current folder


#Param([array]$files,$pass)
Param($folder,$oname,$pass)
$word = NEW-OBJECT -COMOBJECT WORD.APPLICATION
$folder
# docxファイルまたはdocファイルを検索する
$files = Get-ChildItem $folder -Recurse| Where-Object{($_.Name -match "docx$" -or $_.Name -match "doc$") -and ($_.Name -like "*議事録*")}
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
        # 拡張子をpdfに変更して保存する
        $tname0=$homepath.Path + "\tmp\" + $file.Name.Replace($file.Extension,".pdf")
        $tname=$tname0.Replace(" ","_")
        $doc.SaveAs([ref] $tname,[ref] 17)        
        $t2name = $tname.Replace("C:","/mnt/c")
        $pdfs = @("$pdfs",$t2name.Replace("\","/"))
        Write-Host "$($file.FullName)をPDF変換しました"
        $doc.Close(0)
    }
    catch
    {
        Write-Host "[ERROR]$($file.FullName)のPDF変換に失敗しました"
    }
}

$word.Quit()
$pdfunitecmd = "wsl.exe /usr/bin/pdftk $pdfs cat output ./$oname user_pw $pass"
$pdfunitecmd
Invoke-Expression $pdfunitecmd
