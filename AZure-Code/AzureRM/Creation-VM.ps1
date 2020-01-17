
#Credential pour connection azure 
$Credential = Get-Credential -message "Azure Credential"-UserName "pescorbiac@Artemys.com" -Tenant
#Module Azure
Import-Module AzureRM
#connection Azure
Connect-AzureRmAccount -Credential $credential 

#Emplacement des ressource 
#Get-AzureRmLocation | sort DisplayName | Select DisplayName
$locationName = "West Europe"

#Groupe de ressource
#Exemple création : : : : New-AzureRmResourceGroup -Name "myResourceGroup" -Location "West US"
$ResourceGroupName  = "LAB"

#Nom de la VM
$ComputerName = "MyVM"
$VMname = "VMtest03"

#Credential Admin VM
$VMLocalAdminUser = "Ostechno"
$VMLocalAdminSecurePassword = ConvertTo-SecureString "KingPr1nts" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

#VM size
$VMSize = "Standard_A2_V2"

#Virtual Network
#Visualiser Vnet : : : Get-AzureRmVirtualNetwork
#az network vnet create --name VNETLAB --resource-group LAB --location westeurope --address-prefix 10.0.0.0/16 --subnet-name LAN --subnet-prefix 10.0.0.0/24
$Vnet = "VNETLAB"
#$Vnet1 = Get-AzureRmVirtualNetwork -name $Vnet -ResourceGroupName LAB
#Virtual Network
#$VSubnet = Get-AzureRmVirtualNetwork -Name VNETLAB -ResourceGroupName LAB | Get-AzureRmVirtualNetworkSubnetConfig | Format-Table
$VSubnet = "VMtest1Subnet"

#config carte reseau 
$NICName = "NIC"+$VMname
$publicIpName = "IpPub"+$VMname
$publicIp = New-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $ResourceGroupName -AllocationMethod Static -Location $locationName

$vnet = Get-AzureRmVirtualNetwork -Name $Vnet -ResourceGroupName $ResourceGroupName
$Subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $VSubnet -VirtualNetwork $vnet
$PIP1 = Get-AzureRmPublicIPAddress -Name $publicIpName -ResourceGroupName $ResourceGroupName

$IPConfig1 = New-AzureRmNetworkInterfaceIpConfig -Name "IPConfig-1" -Subnet $Subnet -PublicIpAddress $PIP1 -Primary

$NIC = New-AzureRmNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroupName -Location $LocationName -IpConfiguration $IpConfig1

$VirtualMachine = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName $ComputerName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate
$VirtualMachine = Add-AzureRmVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
#Get-AzureRmVMImagePublisher -Location "West Europe -------- trouver image souhaité.
$VirtualMachine = Set-AzureRmVMSourceImage -VM $VirtualMachine -PublisherName 'MicrosoftWindowsServer' -Offer 'WindowsServer' -Skus '2016-Datacenter' -Version latest

New-AzureRmVM -ResourceGroupName $ResourceGroupName -Location $LocationName -VM $VirtualMachine -Verbose

