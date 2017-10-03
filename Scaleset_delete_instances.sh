#! /bin/bash

# -----------------------------------
# Given a scale set name, a resource group and a list of instance-id 
#   delete such instances from the scale set.
#   The list of instance-id is a list of blank-separated integers, such as
#     "2 4 5" or "3"
# -------------------------------

test $# -ge 3 || { echo 'ARGS: scale_set group instanceId+' ; exit 1 ; }

ss=$1
group=$2
shift 2
instanceIds="$*"

az vmss delete-instances --instance-ids ${instanceIds} -n $ss -g $group
