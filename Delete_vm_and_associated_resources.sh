#! /bin/bash

# -----------------------------------
# Given a VM name and a resource group, this script deletes the
#   VM and tentatively all the associated resources
# -------------------------------

test $# -ge 2 || { echo 'ARGS: vm group' ; exit 1 ; }

vm=$1
group=$2

vmInfo=$(az vm show -g $group -n $vm)
vmId=$(echo $vmInfo | python -mjson.tool | grep '"id"' | grep virtualMachines | awk '{print $2}' | tr -d '","')
nicId=$(az vm nic list -g $group --vm-name $vm | python -mjson.tool | grep '"id"' | awk '{print $2}' | tr -d '","')
ipId=$(az vm list-ip-addresses -g $group -n $vm | python -mjson.tool | grep '"id"' | awk '{print $2}' | tr -d '","')
nsgId=$(az network nic show --ids $nicId | python -mjson.tool | grep '"id"' | grep networkSecurityGroup | awk '{print $2}' | tr -d '","')
diskIds=$(echo $vmInfo | python -mjson.tool | grep '"id":' | grep -i disk | awk '{print $2}' | tr -d '","')

## echo vmId $vmId
## echo nicId $nicId
## echo ipId $ipId
## echo nsgId $nsgId
## echo diskIds $diskIds

for obj in $vmId ; do
echo deleting vm $obj
az resource delete --id $obj
done
echo

for obj in $nicId ; do
echo deleting nic $obj
az resource delete --id $obj
done
echo

for obj in $ipId ; do
echo deleting ip $obj
az resource delete --id $obj
done
echo

for obj in $nsgId; do
echo deleting nsg $obj
az resource delete --id $obj
done
echo

for obj in $diskIds ; do
echo deleting disk $obj
az resource delete --id $obj
done
echo

