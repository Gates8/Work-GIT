$vCenter = $global:DefaultVIServers
$Output = "Change Me"

if($global:DefaultVIServers -eq $Null -or $global:DefaultVIServer -eq $Null){
    Connect-VIServer VC01
    Connect-VIServer VC02
}


Get-VMHost -Name *|Get-View | Select @{N="Host";E={$_.Name}},
@{N="Connection";E={$_.Runtime.ConnectionState}},
@{N="PowerState";E={$_.Runtime.PowerState}},
@{N="Maintenance";E={$_.Runtime.InMaintenanceMode}},
@{N="Overall Status";E={$_.Summary.OverallStatus}},
@{N="Reboot Required";E={$_.Summary.RebootRequired}},
@{N="SSH Enabled";E={Get-VMHostService -VMHost $_.Name | Where {$_.Key -eq "TSM-SSH"} | Select-Object Running}},
@{N="Lockdown Mode";E={$_.Config.LockdownMode}},
@{N="MGMT IP";E={$_.Summary.ManagementServerIP}},
@{N="Date/Time";E={Get-Date}} | Sort Host | Export-CSV $Output

Write-Host "Disconnecting from vCenters"
Disconnect-VIServer *