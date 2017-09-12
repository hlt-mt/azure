#! /bin/bash

set -e

# ----------------------------------------------
# This script creates a new image from a give VM
#
# Please update variables
#   imgName
#   vmName
#   resGroup
# to meet your requirements
#
# ***************
# ** IMPORTANT **
# ***************
# remember to deprovision the VM before cloning, i.e. ssh the VM
# and run the following command   
#   sudo waagent -deprovision -force 
# Please note that after such command the VM is no more accessible: so
# after creating the image it is recommend to delete th VM.

# ----------------------------------------------


# -----------------
# main variables
#
imgName=ROL-image-a
vmName=ROL-test-a
resGroup=ROL-test

# -----------------
# default variables
#
user=hlt_admin
passwd=HltMtUser2017


# 0) deallocate the actual VM with all the above pars
args="--resource-group $resGroup --name $vmName"
az vm stop $args
az vm deallocate $args

# 1) generalize the actual VM with all the above pars
#
args="--resource-group $resGroup --name $vmName"
az vm generalize $args

# 2) create the image 
args="--resource-group $resGroup --name $imgName"
args="$args --source $vmName"
az image create $args

echo exit code $?
