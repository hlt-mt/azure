#! /bin/bash

set -e

# -------------------------------------------------------
# This script gives a user the permissions to manage each 
#   vm in vmList 
#
# Please update variables
#   group
#   user
#   vmList (can include a single vm)
# to meet your requirements
# -----------------------------------

group=WMT-2017
user='digangi@fbk.eu'
vmList='test2-a test2-b'


role='Virtual Machine Contributor'


for vm in $vmList
do

vmId=$(az vm show -g $group -n $vm | python -mjson.tool | grep '"id"' | grep virtualMachines | awk '{print $2}' | tr -d '","')
nicId=$(az vm nic list -g $group --vm-name $vm | python -mjson.tool | grep '"id"' | awk '{print $2}' | tr -d '","')
ipId=$(az vm list-ip-addresses -g $group -n $vm | python -mjson.tool | grep '"id"' | awk '{print $2}' | tr -d '","')

for resId in $vmId $nicId $ipId
do
  az role assignment create --assignee $user --role "$role" --scope $resId 
  echo exit code $?
  echo
done

done # for vm 
