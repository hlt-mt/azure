#! /bin/bash

set -e

# -----------------------------------
# This script creates a new VM 
#
# Please update variables
#   location
#   imgName
#   destGroup
#   destSize
#   destStorageType
# to meet your requirements
# -----------------------------------

location=southcentralus
imgName=UbuntuLTS
destGroup=ROL-test
destSize=Standard_NC6
destStorageType=Standard_LRS

# -----------------
# default variables
#
user=fbk
passwd=fbk_user_2017

# -----------------
# derived variables
#
destVmName=ROL-test-a


# 0) create the actual VM with all the above pars
#
args="-g $destGroup -n $destVmName"
args="$args --image $imgName"
args="$args --authentication-type password"
args="$args --admin-username $user --admin-password $passwd"
args="$args --size $destSize"

az vm create $args
echo exit code $?

