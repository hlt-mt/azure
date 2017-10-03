#! /bin/bash

# -----------------------------------
# Given a scale set name and a resource group, this script return the
#   private IPs of the internal VMs of the scale set
# -------------------------------

test $# -ge 2 || { echo 'ARGS: scale_set group' ; exit 1 ; }

ss=$1
group=$2

az vmss get-instance-view -g $group -n $ss --instance-id \* \
  | grep '"code":' | grep PowerState | awk '{print $2}' \
  | tr -d '",' | cut -d'/' -f2
