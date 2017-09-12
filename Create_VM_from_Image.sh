#! /bin/bash

set -e

# -----------------------------------
# This script creates a new resource group containing a new VM 
#    and all the resources it needs.
#
# Please update variables
#   imgId
#   destGroup
#   destSize
# to meet your requirements
# -----------------------------------

destGroup=ROL-test
destSize=Standard_NC6

# -----------------
# default variables
#
user=hlt_admin
passwd=HltMtUser2017

# -----------------
# derived variables
#
destVmName=ROL-test-from-image-a
imgName=ROL-image-a

# 0) create the actual VM with all the above pars
#
args="--resource-group $destGroup --name $destVmName"
args="$args --image $imgName"
args="$args --authentication-type password"
args="$args --admin-username $user --admin-password $passwd"
args="$args --size $destSize"
args="$args --no-wait"
az vm create $args

echo exit code $?

