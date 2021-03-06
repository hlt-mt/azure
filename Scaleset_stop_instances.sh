#! /bin/bash

# -----------------------------------
# stop and deallocate the instances (= internal VMs) of a scale set
# -------------------------------

test $# -ge 2 || { echo 'ARGS: scale_set group' ; exit 1 ; }

ss=$1
group=$2

az vmss deallocate -g $group -n $ss
