$Global:date_time = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
$Global:path_file = "\\server\p3db\_soft\*.rar"
$Global:data_old = "d:\_Scripts\PS\Check_modify_files_send_email\data_old" 
$Global:data_new = "d:\_Scripts\PS\Check_modify_files_send_email\data_new"
$Global:data_different = "d:\_Scripts\PS\Check_modify_files_send_email\files_data_different.txt" 
$Global:log = "d:\_Scripts\PS\Check_modify_files_send_email\Check_modify_files_send_email.log"

$Global:From = "p3db_soft_changes_folder@neolant-srv.ru"
#$Global:To = "n.sergeev@neolant.com" 
$Global:To = "neosphere@neolant-srv.ru" 
$Global:SMTPServer = "mail.loc" 
$Global:Subject = "Changes files RAR in the folder !!!"

Copy-Item $data_new -Destination $data_old
Get-ChildItem "\\server\p3db\_soft\*.rar" | Out-File $data_new

if ($a = (Get-ChildItem $path_file | Where{$_.LastWriteTime -ge (Get-Date).AddHours(-1)})) 
{
    $aa = "Changes: - $a"
    Write-Host $aa
    "$date_time $aa" | Out-File -Append $log
    $Body = $aa
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
}
elseif (@(Compare-Object $(Get-Content $data_old -encoding byte) $(Get-Content $data_new -encoding byte) -sync 0).length -ne 0) 
{
    Compare-Object -referenceobject $(Get-Content $data_old) -differenceobject $(Get-Content $data_new) | Out-File $data_different
    $bb = "Changes: files different"
    Write-Host $bb 
    "$date_time $bb" | Out-File -Append $log  
    $Body = "Changes: Files different in the Folder \\server\p3db\_soft\"
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $data_different
    
}
else 
{
    $cc = "No changes to RAR files in folder !!!"
    Write-Host $cc
    "$date_time $cc" | Out-File -Append $log 
     
}
