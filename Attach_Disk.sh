#! /bin/bash

set -e

# -----------------------------------
# This script attaches a new disk (Standard_LRS, 512Gb) to an existing VM 
#
# Please update variables
#   destGroup
#   destSize
#   destDiskType
# to meet your requirements
# -----------------------------------

destGroup=ROL-test

# -----------------
# default variables
#
user=hlt_admin
passwd=HltMtUser2017

# -----------------
# derived variables
#
destVmName=ROL-test-a
destDiskName="$destVmName-DataDisk"
destDiskSize="512"
destDiskType="Standard_LRS"

# 0) attach a new disk to the specified VM
args="--resource-group $destGroup --vm-name $destVmName"
args="$args --disk $destDiskName"
args="$args --size-gb $destDiskSize"
args="$args --sku $destDiskType"
args="$args --new"
az vm disk attach $args

echo exit code $?

