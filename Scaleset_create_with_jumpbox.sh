#! /bin/bash

set -e
set -x

# ------------------
# variables to update
# ------------------

location=southcentralus ; # location=westeurope
destGroup=ss-test2
instanceImage="Canonical:UbuntuServer:14.04.4-LTS:latest"
instanceSize=Standard_A2
instanceNum=4
instanceDataDiskSize=512
user=hlt_admin
passwd=HltMtUser2017
namePrefix=JB
#
#
# -------------------------------
# do NOT change these variables !
# -------------------------------
destVnet=${namePrefix}-vnet
destSubnet=${namePrefix}-sn
destSubnetPrefix="10.0.0.0/24"
destIp=${namePrefix}-ip
destNsg=${namePrefix}-nsg
destNic=${namePrefix}-nic
destVmName=${namePrefix}-jumpbox
destVmSize=Standard_A1
destVmImage="Canonical:UbuntuServer:14.04.4-LTS:latest"
destSs=${namePrefix}-ss


checkFlag=$(az group exists -n $destGroup)
if test "$checkFlag" == false
then
  az group create -n $destGroup -l $location
fi


# 1) create virtual net and subnet
args="-n $destVnet -g $destGroup -l $location"
args="$args --subnet-name $destSubnet --subnet-prefix $destSubnetPrefix"
az network vnet create $args

# 2) create public-ip
az network public-ip create -n $destIp -g $destGroup -l $location

# 3) create nsg (network security group) with rule "allow ssh"
az network nsg create -g $destGroup -n $destNsg
#
args="-g $destGroup --nsg-name $destNsg -n default-allow-ssh"
args="$args --priority 1000 --direction Inbound"
args="$args --protocol Tcp --destination-port-range 22"
az network nsg rule create $args

# 4) create nic (network card interface)
args="-n $destNic -g $destGroup --subnet $destSubnet --vnet-name $destVnet"
args="$args --public-ip-address $destIp -l $location"
args="$args --network-security-group $destNsg" 
az network nic create $args

# 5) create the jumpbox VM with all the above pars
#
args="-g $destGroup -n $destVmName"
args="$args --image $destVmImage --size $destVmSize"
args="$args --authentication-type password"
args="$args --admin-username $user --admin-password $passwd"
args="$args --nics $destNic"
args="$args --storage-sku Standard_LRS"
az vm create $args

# 6) create the mvss in the same virtual net
#
args="-g $destGroup -n $destSs"
args="$args --image $instanceImage --vm-sku $instanceSize"
args="$args --instance-count $instanceNum"
args="$args --authentication-type password"
args="$args --admin-username $user --admin-password $passwd"
args="$args --storage-sku Standard_LRS"
if test $instanceDataDiskSize -gt 0
then
  # add data disk if needed
  args="$args --data-disk-sizes-gb $instanceDataDiskSize"
fi
args="$args --vnet-name $destVnet --subnet $destSubnet"

az vmss create $args --public-ip-address ""
echo exit code $?
