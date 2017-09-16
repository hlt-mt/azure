#! /bin/bash

# -----------------------------------
# Given a scale set name and a resource group, this script return the
#   private IPs of the internal VMs of the scale set
# -------------------------------

test $# -ge 2 || { echo 'ARGS: scale_set group' ; exit 1 ; }

ss=$1
group=$2

tmpFile=/tmp/gpioss.$$

az vmss list-instances -g $group -n $ss > $tmpFile
instanceIdList=$(cat $tmpFile | grep '"instanceId":' | awk '{print $2}' | tr -d ',"')
## nicIdList=$(cat $tmpFile | grep '"id":' | grep networkInterfaces | awk '{print $2}' | tr -d ',"')

for iid in $instanceIdList
do
  nicId=$(cat $tmpFile | grep '"id":' | grep "virtualMachines/${iid}/" | grep networkInterfaces | awk '{print $2}' | tr -d ',"')
  ip=$(az resource show --ids $nicId | grep '"privateIPAddress":' | awk '{print $2}' | tr -d ',"')
  echo instanceId:$iid $ip
done

\rm $tmpFile

