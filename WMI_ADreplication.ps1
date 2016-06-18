$WmiParam = @{
    Class = 'MSAD_ReplNeighbor'
    Namespace = 'root\MicrosoftActiveDirectory'
    Filter = "NamingContextDN = '$(-join ([adsi]'').distinguishedname)'"
}
$DateTimeOfLastSyncSuccess = @{
    Name = 'DateTimeOfLastSyncSuccess'
    Expression = {[Management.ManagementDateTimeConverter]::ToDateTime($_.TimeOfLastSyncSuccess)}
}
$ReadableReplicaFlags = @{
    Name = 'ReadableReplicaFlags'
    Expression = {
        Switch ($_.ReplicaFlags) {
            {$_ -bor 0x10} {'DS_REPL_NBR_WRITEABLE'}
            {$_ -bor 0x20} {'DS_REPL_NBR_SYNC_ON_STARTUP'}
            {$_ -bor 0x40} {'DS_REPL_NBR_DO_SCHEDULED_SYNCS'}
            {$_ -bor 0x80} {'DS_REPL_NBR_USE_ASYNC_INTERSITE_TRANSPORT'}
            {$_ -bor 0x200} {'DS_REPL_NBR_TWO_WAY_SYNC'}
            {$_ -bor 0x800} {'DS_REPL_NBR_RETURN_OBJECT_PARENTS'}
            {$_ -bor 0x10000} {'DS_REPL_NBR_FULL_SYNC_IN_PROGRESS'}
            {$_ -bor 0x20000} {'DS_REPL_NBR_FULL_SYNC_NEXT_PACKET'}
            {$_ -bor 0x200000} {'DS_REPL_NBR_NEVER_SYNCED'}
            {$_ -bor 0x1000000} {'DS_REPL_NBR_PREEMPTED'}
            {$_ -bor 0x4000000} {'DS_REPL_NBR_IGNORE_CHANGE_NOTIFICATIONS'}
            {$_ -bor 0x8000000} {'DS_REPL_NBR_DISABLE_SCHEDULED_SYNC'}
            {$_ -bor 0x10000000} {'DS_REPL_NBR_COMPRESS_CHANGES'}
            {$_ -bor 0x20000000} {'DS_REPL_NBR_NO_CHANGE_NOTIFICATIONS'}
            {$_ -bor 0x40000000} {'DS_REPL_NBR_PARTIAL_ATTRIBUTE_SET'}
        }
    }
}
Get-WmiObject @WmiParam | Select-Object -Property SourceDsaCN,SourceDsaSite,$DateTimeOfLastSyncSuccess,$ReadableReplicaFlags
