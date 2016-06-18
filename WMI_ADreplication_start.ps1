$WmiParam = @{
    Namespace = 'root\MicrosoftActiveDirectory'
    Query = "Select * From MSAD_ReplNeighbor Where NamingContextDN = '$(-join ([adsi]'').distinguishedname)'"
}
Get-WmiObject @WmiParam | ForEach-Object {
    Write-Output "Replicate domain partition: $($_.Domain) from DC: $($_.SourceDsaCN) in the $($_.SourceDsaSite) site"
    $_.SyncNamingContext()
}