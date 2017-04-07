#! /bin/bash

set -e

# -----------------------------------
# This scripts create a new resource group containing a new VM 
#    and all the resources it needs.
#
# Please update variables
#   location
#   imgId
#   destGroup
#   destSize
# to meet your requirements
# -----------------------------------

location=southcentralus
imgId=/subscriptions/199a0021-75d4-4e28-84e2-0aa49020bbe5/resourceGroups/WMT-2017/providers/Microsoft.Compute/images/nmt-theano-v0-9-template-image-20170329133925
destGroup=ROL-test
destSize=Standard_NC6

# -----------------
# default variables
#
user=hlt_admin
passwd=HltMtUser2017

# -----------------
# derived variables
#
destVmName=ROL-test-a
destVnet=${destVmName}-vnet
destSubnetName="${destVmName}-sn"
destSubnetPrefix="10.0.0.0/24"
destIp=${destVmName}-ip
destNsg=${destVmName}-nsg
destNic=${destVmName}-nic


# 0) create resource group if not existent
checkFlag=$(az group exists -n $destGroup)
if test "$checkFlag" == false
then
  az group create -n $destGroup -l $location
fi

# 1) create virtual net and subnet
args="-n $destVnet -g $destGroup -l $location"
args="$args --subnet-name $destSubnetName --subnet-prefix $destSubnetPrefix"
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
args="-n $destNic -g $destGroup --subnet $destSubnetName --vnet-name $destVnet"
args="$args --public-ip-address $destIp -l $location"
args="$args --network-security-group $destNsg" 
az network nic create $args

# 5) create the actual VM with all the above pars
#
args="-g $destGroup -n $destVmName --image $imgId"
args="$args --authentication-type password"
args="$args --admin-username $user --admin-password $passwd"
args="$args --nics $destNic --size $destSize"
args="$args --storage-sku Standard_LRS"

az vm create $args
echo exit code $?

