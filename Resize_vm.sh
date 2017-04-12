#! /bin/bash

set -e

# -------------------------------------------------------
# This script gives change the size of a VM
#
# Please update variables
#   group
#   vm
#   size
# to meet your requirements
# -----------------------------------

grp=WMT-2017
vm=WMT-mmt-a
size=Standard_D5_v2

az vm deallocate -g $grp -n $vm
az vm resize -g $grp -n $vm --size $size
