#! /bin/bash

set -e

# -----------------------------------
# This script creates a new resource group containing a new VM 
#    and all the resources it needs.
#
# Please update variables
#   imgName
#   destVmName
#   destGroup
# to meet your requirements
# -----------------------------------


destGroup=FBKResourceGroup

# -----------------
# default variables
#
user=hlt_admin
passwd=HltMtUser2017

# -----------------
# derived variables
#
destVmName=ROL-test-a
imgName=ROL-image-a

####
## Remember to deprovision the VM to clone
## Remember that later on the VM is no more accessible
## From the VM, run the following command 
## sudo waagent -deprovision -force 
####

# 0) deallocate the actual VM with all the above pars
args="--resource-group $destGroup --name $destVmName"
az vm stop $args
az vm deallocate $args

# 1) generalize the actual VM with all the above pars
#
args="--resource-group $destGroup --name $destVmName"
az vm generalize $args

# 2) create the image 
args="--resource-group $destGroup --name $imgName"
args="$args --source $destVmName"
az image create $args

echo exit code $?

