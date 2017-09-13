# by default the first attached disk is called "sdc", the second "sdd", the third "sde", etc.
disk=sdc 

# use the actual username
user=fbk

(echo n; echo p; echo 1; echo ; echo ; echo w) | sudo fdisk /dev/${disk}
sudo mkfs -t ext4 /dev/${disk}1
sudo mkdir /datadrive && sudo mount /dev/${disk}1 /datadrive

sudo cp /etc/fstab /etc/fstab_BCK

UUID=`sudo -i blkid | grep $disk | tr '"' ' ' | awk '{print $3}'`
(cat /etc/fstab ; echo "UUID=$UUID   /datadrive  ext4    defaults,nofail,barrier=0   1  2" ) > /tmp/fstab$$  &&  sudo cp /tmp/fstab$$ /etc/fstab &&  rm /tmp/fstab$$

# creates two directories for user data and software
sudo mkdir -p /datadrive/software
sudo mkdir -p /datadrive/data

# change the ownership of the two directories for user data and software
sudo chown -R ${user}:${user} /datadrive/software
sudo chown -R ${user}:${user} /datadrive/data


