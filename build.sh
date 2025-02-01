#!/bin/bash

############################################################
#                          ENV VARS                        #
############################################################

export BUILD_USERNAME=rvsmooth
export BUILD_HOSTNAME=crave
export KBUILD_USERNAME=rvsmooth
export KBUILD_HOSTNAME=crave
export TZ=Asia/Kolkata

############################################################
#                         FUNCTIONS                        #
############################################################

function repo_set(){
	rm -rf .repo/local_manifests
	repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
	git clone https://github.com/RMX1821-dev/local_manifests -b main .repo/local_manifests
}

function sync_projects(){

	/opt/crave/resync.sh
}

function lunch_build(){

	if [[ "$USERDEBUG" == "1" ]]; then
		lunch lineage_RMX1821-userdebug
	else 
		lunch lineage_RMX1821-user
	fi
}

############################################################
#                         EXECUTION                        #
############################################################

source build/envsetup.sh

if [[ "$CLEAN_BUILD" == "1" ]]; then
	repo_set
	sync_projects
	lunch_build
	make installclean
	m bacon
else
	echo "Doing dirty build."
	lunch_build
	make installclean
	m bacon
fi


