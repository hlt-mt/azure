#! /bin/bash

set -e

# ---------------------------------------------------
# This script creates a new VM starting from an image
#
# Please update variables
#   imgName
#   destGroup
#   destSize
#   destVmName
# to meet your requirements
# -----------------------------------

imgName=ROL-image-a
destGroup=ROL-test
destSize=Standard_NC6
destVmName=ROL-test-from-image-a

# -----------------
# default variables
#
user=hlt_admin
passwd=HltMtUser2017


# create the actual VM with all the above pars
#
args="--resource-group $destGroup --name $destVmName"
args="$args --image $imgName"
args="$args --authentication-type password"
args="$args --admin-username $user --admin-password $passwd"
args="$args --size $destSize"
args="$args --no-wait"
az vm create $args

echo exit code $?
