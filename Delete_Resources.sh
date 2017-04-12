#! /bin/bash

# -------------------------------------------------------
# This script removes several resources in the group $rgroup
#
# Each fo the following variable:
#   vm, nic, ip, vnet, nsg, storacc, disk
# may contains a list of resource names to be removed.
# Examples of lists:
#   vm='test1 test2' # multiple values
#   vm='test1'       # single value
#   vm=              # empty list
# -----------------------------------



rgroup=my_resource_grp

vm=my_vm_list
nic=my_netowrkinterfacecard_list
ip=test-nvidia-ip
vnet=my_vnet_list
nsg=my_networksecuritygroup_list
storacc=my_storage_account_list
disk=my_disk_list



for obj in $vm ; do
  az vm delete -g $rgroup -n $obj --yes
done

for obj in $nic ; do
az network nic delete -g $rgroup -n $obj
done

for obj in $ip ; do
az network public-ip delete -g $rgroup -n $obj
done

for obj in $vnet ; do
az network vnet delete -g $rgroup -n $obj
done

for obj in $nsg ; do
az network nsg delete -g $rgroup -n $obj
done

for obj in $storacc ; do
az storage account delete -g $rgroup -n $obj --yes
done

for obj in $disk ; do
az disk delete -g $rgroup -n $obj
done

