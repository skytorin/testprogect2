$path_file_1 = "\\server\p3db\_soft\*.rar"

if ($a = (Get-ChildItem $path_file_1 | Where{$_.LastWriteTime -ge (Get-Date).AddHours(-1)}))
 {
    Write-Host "New files: - $a"
    $EmailFrom = "p3db_soft_new_files@neolant-srv.ru"
    $EmailTo = "neosphere@neolant-srv.ru" 
  # $EmailTo = "n.sergeev@neolant.com" 
    $Subject = "New files to \\server\p3db\_soft\ " 
    $Body = "New files: - $a"
    $SMTPServer = "mail.loc" 
    $SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 25) 
    $SMTPClient.Timeout = 1000
    $SMTPClient.EnableSsl = $False
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
 }
    else
 {
    Write-Host "All Files Old !!!"
 }