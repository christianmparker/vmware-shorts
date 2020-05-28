# Variables
$vCenter = "vcsa01.baylyparker.local"
$vCenterUser = "baylyparker\christian"
$vCenterPass = "VMware1!"
$SMTPServer = "nas01.baylyparker.local"
$To = "christianmparker@baylyparker.local"
$From = "vcsa01@baylyparker.local"

# HTML formatting
$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid red; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid; background-color: #4CAF50; color: white; padding: 5px; }"
$style = $style + "TD{border: 1px solid; padding: 5px; }"
$style = $style + "</style>"
$date = Get-Date -Format "dddd dd/MM/yyyy HH:mm K"

# Connect to vCenter"
CLS
Write-Host "Connecting to $vCenter" -ForegroundColor Blue
Connect-VIServer -Server $vCenter -User $vCenterUser -Password $vCenterPass -Force | Out-Null
Write-Host "   Connected to $vCenter" -ForegroundColor Green

# Get list of VMs with snapshots
Write-Host "Generating VM snapshot report" -ForegroundColor Blue
$SnapshotReport = Get-vm | Get-Snapshot | Select-Object VM,Description,PowerState,SizeGB | Sort-Object SizeGB | ConvertTo-Html -Head $style | Out-String
Write-Host "   Completed" -ForegroundColor Green

# Sending email report
Write-Host "Sending VM snapshot report" -ForegroundColor Blue
$htmlbody = @" 
<html>
<body>
$SnapshotReport
</body> 
</html> 
"@ 
Send-MailMessage -smtpserver $SMTPServer -From $From -To $To -Subject "Snapshot Email Report for $Date" -BodyAsHtml -Body $htmlbody
Write-Host "   Completed" -ForegroundColor Green

#Disconnecting vCenter
Disconnect-VIServer -Server $vCenter -Force -Confirm:$false
Write-Host "Disconnecting to $vCenter" -ForegroundColor Blue