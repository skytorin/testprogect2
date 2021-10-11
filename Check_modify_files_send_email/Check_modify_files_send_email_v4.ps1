$Global:path_file_1 = "\\server\p3db\_soft\*.rar"
$Global:data_old = "d:\_Scripts\PS\Check_modify_files_send_email\data_old" 
$Global:data_new = "d:\_Scripts\PS\Check_modify_files_send_email\data_new"
$Global:data_different = "d:\_Scripts\PS\Check_modify_files_send_email\files_data_different.txt" 

$Global:From = "p3db_soft_changes_folder@neolant-srv.ru"
$Global:To = "n.sergeev@neolant.com" 
#$Global:SMTPClient.Timeout = 1000
#$Global:SMTPClient.EnableSsl = $False
$Global:SMTPServer = "mail.loc" 
#$Global:SMTPPort = "25"
$Global:Subject = "Changes files RAR in the folder !!!"

Copy-Item $data_new -Destination $data_old
Get-ChildItem "\\server\p3db\_soft\*.rar" | Out-File $data_new

if ($a = (Get-ChildItem $path_file_1 | Where{$_.LastWriteTime -ge (Get-Date).AddHours(-1)})) 
{
    Write-Host "Changes: - $a"
    $Body = "Changes: - $a"
    #$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, $SMTPPort) 
    #$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
}
elseif (@(Compare-Object $(Get-Content $data_old -encoding byte) $(Get-Content $data_new -encoding byte) -sync 0).length -ne 0) 
{
    Compare-Object -referenceobject $(Get-Content $data_old) -differenceobject $(Get-Content $data_new) | Out-File $data_different
    Write-Host "Changes: files different"     
    $Body = "Changes: Files different in the Folder \\server\p3db\_soft\"
    #$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, $SMTPPort)
    #$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
    Send-MailMessage -From $From -to $To -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer -Attachments $data_different
}
else 
{
    Write-Host "All Files Old !!!"
}

