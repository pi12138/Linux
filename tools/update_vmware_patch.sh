#!/usr/bin/env bash

# 用于更新VMware的补丁
# dnf install make gcc automake kernel-devel-version

VMWARE_VERSION=$(vmware-installer -l | grep "vmware-workstation" | awk '{print $2}' | awk -F. -v OFS="."  '{print $1,$2,$3}')
LINUX_KERNEL_VERSION=$(uname -r | awk -F. -v OFS='.' '{print $1,$2}')
VMWARE_HOST_MODULES='git@github.com:mkubecek/vmware-host-modules.git'
TMP_FOLDER="/tmp/patch-vmware"
VMWARE_PATCH_TAG_VERSION="w${VMWARE_VERSION}-k${LINUX_KERNEL_VERSION}"

rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER
cd $TMP_FOLDER || exit 
git clone $VMWARE_HOST_MODULES
cd vmware-host-modules || exit
git checkout "$VMWARE_PATCH_TAG_VERSION"
git pull
tar -cf vmmon.tar vmmon-only && tar -cf vmnet.tar vmnet-only && sudo cp -v vmmon.tar vmnet.tar /usr/lib/vmware/modules/source/
sudo vmware-modconfig --console --install-all