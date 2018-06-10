Param(
 [string]$ResourceGroupName,
 [string]$LocationName,
 [string]$VMName,
 [string]$SubnetAddressPrefix,
 [string]$VnetAddressPrefix,
#  [string] $RmProfilePath =$(throw "Parameter missing: -RmProfilePath RmProfilePath"),
 [string]$VMSizeName ="Standard_A2",
 [string]$PublisherName = 'Canonical',
 [string]$OfferName = 'UbuntuServer',
 [string]$SkusName = '16.04.0-LTS',
 [string]$UserName = 'adminuser',
 [string]$Password = 'Password@1234'
)
$connectionName = "AzureRunAsConnection"

    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName  
    $tenantID = $servicePrincipalConnection.TenantId
    $applicationId = $servicePrincipalConnection.ApplicationId
    $certificateThumbprint = $servicePrincipalConnection.CertificateThumbprint

    "Logging in to Azure..."
    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $tenantID `
        -ApplicationId $applicationId `
        -CertificateThumbprint $certificateThumbprint

        New-AzureRmResourceGroup -Name $ResourceGroupName -Location $LocationName
        $RandomNum = Get-Random -minimum 100 -maximum 999
        $SubnetName = "subnet1-"+$RandomNum
        $VnetName = $ResourceGroupName+"-vnet"+$RandomNum
        $IpName = $VMName+"-ip"+$RandomNum
        $NicName = $VMName+"-ni"+$RandomNum

          Write-Host "Auto generate network interface $NicName" -ForegroundColor Green
          
          $Subnet = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetAddressPrefix -ErrorAction Stop     
          $Vnet = New-AzureRmVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroupName -Location $LocationName -AddressPrefix $VnetAddressPrefix -Subnet $Subnet -ErrorAction Stop        
         
          $Pip = New-AzureRmPublicIpAddress -Name $IpName -ResourceGroupName $ResourceGroupName -Location $LocationName -AllocationMethod Dynamic -ErrorAction Stop       
          
$Nic = New-AzureRmNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName -Location $LocationName -SubnetId $Vnet.Subnets[0].Id -PublicIpAddressId $Pip.Id
echo $Nic

          $StrPass = ConvertTo-SecureString -String $Password -AsPlainText -Force
          $Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($UserName, $StrPass)


        #Choose virtual machine size, set computername and credential
     $VM = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSizeName -ErrorAction Stop
     $VM = Set-AzureRmVMOperatingSystem -VM $VM -Linux -ComputerName $VMName -Credential $Cred EnablePasswordAuthentication -ErrorAction Stop
                           
    #Choose source image
    $VM = Set-AzureRmVMSourceImage -VM $VM -PublisherName $PublisherName -Offer $OfferName -Skus $SkusName -Version "latest" -ErrorAction Stop

    #Add the network interface to the configuration.
    $VM = Add-AzureRmVMNetworkInterface -VM $VM -Id $Nic.Id -ErrorAction Stop
                           


    New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VM -ErrorAction Stop
  