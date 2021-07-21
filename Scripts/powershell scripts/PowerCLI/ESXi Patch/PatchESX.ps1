$ViServer = "FQDN of vCenter Server"
#Rebooting to apply VIB ESXi650-202102001
$VIBPath = "/vmfs/volumes/PROD01/AVIBS/ESXi650-202102001/metadata.zip"

$VIHosts = "Z:\Austin\Anything Related to VMWare\Anything Related to ESXi\Scripts\Useful\ESXi Patch\ESX-22-32.txt"

Connect-VIServer $ViServer

$ESXi = Get-Content $VIHosts | %{Get-VMHost $_}


Function PatchESX($CurrentServer){
    $ServerName = $CurrentServer.Name

    Write-Host "***** Patching $ServerName *****" -ForegroundColor Yellow 

    #Install Patch
    Get-VMHost $CurrentServer | Install-VMHostPatch -HostPath $VIBPath
}

ForEach($ESXiServer in $ESXi){
    PatchESX($ESXiServer)
}
