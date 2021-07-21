$ConnectedvCenterServer = $global:DefaultVIServers

$vCenter = Read-Host "Enter vCenter Server to connect to"
$Target = Read-Host "Hosts ( * for all; comma separated if selecting individual hosts )"

if($ConnectedvCenterServer -eq $Null -or $ConnectedvCenterServer.Name -ne $vCenter){
    Write-Host "Enter vCenter Username/Password" -ForegroundColor Yellow 
    
    $Credential = Get-Credential -Credential "administrator@vsphere.local"
    Connect-VIServer $vCenter -Credential $Credential 
    try{
        if($ConnectedvCenterServer -eq $vCenter){
            Write-Host "Connected to $vCenter"
        }
    }
    catch{
        Write-Host "Failed to connect to $vCenter" -ForegroundColor Red
        Exit 1
    }
}

$Info = @()

ForEach($VMHost in $VMHosts){
    $SSHStatus = (Get-VMHostService -VMHost $VMHost | Where {$_.Key -eq "TSM-SSH"}).Running
    
    $Info += New-Object PSCustomObject -Property @{Host=$($VMHost.Name);Lockdown=$($VMHost.ExtensionData.Config.LockdownMode);SSH=$($SSHStatus)} 
    
}

$Info | FT

Write-Host "`n-------------------------------------------------------" -ForegroundColor Yellow
Write-Host "Currently connected to the following vCenter(s): $vCenter" -ForegroundColor DarkYellow
Write-Host "-------------------------------------------------------" -ForegroundColor Yellow
Write-Host "(1): Enter Lockdown Mode"
Write-Host "(2): Exit Lockdown Mode"
Write-Host "(3): Exit Lockdown Mode and Enable SSH"
Write-Host "(4): Disable SSH and Enter Lockdown Mode"
$EnterExit = Read-Host "`nSelection"


$VMHosts = Get-VMHost $Target | Sort Name
Switch($EnterExit){
    #Enter Lockdown for ESXI
    1{
        foreach($VMHost in $VMHosts){
            try{
                (Get-VMHost $VMHost | Get-View).EnterLockdownMode()
                Write-Host "Entering lockdown mode for $VMHost" -ForegroundColor Green
            }
            catch{
                Write-Host "Could not Enter lockdown for $VMHost" -ForegroundColor Red
            }
        }

        Write-Host "*** Disconnecting from $vCenter ***`n" -ForegroundColor Cyan
        Disconnect-VIServer $vCenter -Confirm:$false
      }
    #Exit Lockdown
    2{
         foreach($VMHost in $VMHosts){
            try{
                (Get-VMHost $VMHost | Get-View).ExitLockdownMode()
                Write-Host "Exiting lockdown mode for $VMHost" -ForegroundColor Green
            }
            catch{
                Write-Host "Cannot Exit lockdown for $VMHost." -ForegroundColor Red
            }
        }
        Write-Host "*** Disconnecting from $vCenter ***`n" -ForegroundColor Cyan
        Disconnect-VIServer $vCenter -Confirm:$false
      }
     #Exit lockdown and Enable SSH
     3{
         foreach($VMHost in $VMHosts){
            try{
                (Get-VMHost $VMHost | Get-View).ExitLockdownMode()
                Write-Host "Exiting lockdown mode for $VMHost" -ForegroundColor Green
                Get-VMHostService -VMHost $VMHost | Where {$_.Key -eq "TSM-SSH"} | Start-VMHostService | Out-Null
                Write-Host "Enabling SSH for $VMHost" -ForegroundColor Yellow
            }
            catch{
                Write-Host "Cannot Exit lockdown or enable SSH for $VMHost." -ForegroundColor Red
            }
        }
        Write-Host "*** Disconnecting from $vCenter ***`n" -ForegroundColor Cyan
        Disconnect-VIServer $vCenter -Confirm:$false
     }
     4{
         foreach($VMHost in $VMHosts){
            try{
                Get-VMHostService -VMHost $VMHost | Where {$_.Key -eq "TSM-SSH"} | Stop-VMHostService -Confirm:$false | Out-Null
                Write-Host "Disabling SSH for $VMHost" -ForegroundColor Yellow
                (Get-VMHost $VMHost | Get-View).EnterLockdownMode()
                Write-Host "Entering lockdown mode for $VMHost" -ForegroundColor Green
            }
            catch{
                Write-Host "Cannot Enter lockdown mode or disable SSH for $VMHost." -ForegroundColor Red
            }
        }
        Write-Host "*** Disconnecting from $vCenter ***`n" -ForegroundColor Cyan
        Disconnect-VIServer $vCenter -Confirm:$false
     }
 }