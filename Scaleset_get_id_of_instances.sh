#! /bin/bash

# -----------------------------------
# Given a scale set name and a resource group, this script return the
#   private IPs of the internal VMs of the scale set
# -------------------------------

test $# -ge 2 || { echo 'ARGS: scale_set group' ; exit 1 ; }

ss=$1
group=$2

instanceIdList=$(az vmss list-instances -g $group -n $ss | grep '"id":' | grep virtualMachineScaleSets | grep -v networkInterfaces| awk '{print $2}' | tr -d ',"')
for iid in $instanceIdList
do
  echo $iid
done
