#!/bin/bash
# This script should be run after a fresh install of OS in the Boxes to adjust the Logical volumes.
name=`hostname`
hname=`echo $name|cut -d . -f1`
echo $hname
hLvm="/dev/mapper/vg_"$hname"-lv_home"
echo $hLvm
rLvm="/dev/mapper/vg_"$hname"-lv_root"
echo $rLvm


umount $hLvm
e2fsck -f $hLvm
resize2fs $hLvm 10G
lvreduce -L 10G $hLvm
#resize2fs $hLvm

lvs
vgs

lvextend -l +100%FREE $rLvm
resize2fs $rLvm
#e2fsck -y $hLvm
mount -t ext4 $hLvm /home


