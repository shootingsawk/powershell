New-WSManSessionOption -SkipCACheck -SkipCNCheck -SkipRevocationCheck
$Job = Start-BitsTransfer `
    -Source http://shootingsawk.lescigales.org/meschersvoisins_aaahh.jpg `
    -Destination c:\temp `
    -TransferType Download `
    -DisplayName pouet `
    -Priority High `
    -Credential $mycreds `
    -Asynchronous `
    -Suspended
bitsadmin /SetSecurityFlags pouet 8
Resume-BitsTransfer -BitsJob $Job -Asynchronous
while (($Job.JobState -eq "Transferring") -or ($Job.JobState -eq "Connecting")) {
    Write-Host $Job.JobId $Job.Jobstate $Job.BytesTransferred $Job.BytesTotal;
    sleep 10;
}
Switch($Job.JobState) {
    "Transferred" {Complete-BitsTransfer -BitsJob $Job; $IsSuccessfulTransfer = $true;}
    "Error" {Write-Host $Job.ErrorDescription; Write-Host;}
    default {}
}