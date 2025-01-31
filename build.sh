#!/bin/bash

# Clean up old manifests and repos
rm -rf .repo/local_manifests

# Initialize repo
repo init -u https://github.com/crdroidandroid/android.git -b 13.0 --git-lfs
git clone https://github.com/RMX1821-dev/local_manifests -b main .repo/local_manifests

# dependencies
sudo apt update -y
sudo apt install -y python-defaults

# Sync repos
/opt/crave/resync.sh

# Export environment variables
export BUILD_USERNAME=rvsmooth
export BUILD_HOSTNAME=crave
export KBUILD_USERNAME=rvsmooth
export KBUILD_HOSTNAME=crave
export TZ=Asia/Kolkata

# Set up the build environment
source build/envsetup.sh

if [[ "$USERDEBUG" == "1" ]]; then
	lunch lineage_RMX1821-userdebug
elif [[ "$USER" == "1" ]]; then
	lunch lineage_RMX1821-user 
else 
	lunch lineage_RMX1821-userdebug
fi

# Clean and build
#
if [[ "$CLEAN_BUILD" == "1" ]]; then
	make installclean
else
	echo "Doing dirty build."
fi

m bacon

