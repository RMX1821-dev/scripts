#!/bin/bash

############################################################
#                          VARS                            #
############################################################
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANDROID_TOP="$(cd ${SCRIPT_DIR}/../ && pwd)"
REPO="main"
CLEAN_BUILD="0"
ANDROID_DIRS=( 
	"device/realme/RMX1821" 
	"kernel/realme/RMX1821"  
	"vendor/realme/RMX1821"
	"vendor/extra"
	"prebuilts/clang/host/linux-x86/clang-r437112"
	"device/mediatek/sepolicy_vndr"
)

############################################################
#                          ENV VARS                        #
############################################################
export BUILD_USERNAME=rvsmooth
export BUILD_HOSTNAME=crave
export KBUILD_USERNAME=rvsmooth
export KBUILD_HOSTNAME=crave

############################################################
#                         FUNCTIONS                        #
############################################################

function repo_set(){
	rm -rf .repo/local_manifests
	repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
	git clone https://github.com/RMX1821-dev/local_manifests -b "${REPO}" .repo/local_manifests
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

function build_clean(){
	repo_set
	sync_projects
	source build/envsetup.sh
	lunch_build
	make installclean
	m bacon
}

function build_dirty(){
	source build/envsetup.sh
	lunch_build
	make installclean
	m bacon
}

function check_project(){
	if [ "$TEST" == "1" ]; then
		REPO=test
	else
		REPO=main
	fi

	for DIR in ${ANDROID_DIRS[@]}; do
		if [ ! -d "${ANDROID_TOP}/${DIR}" ]; then
			echo "Projects not found"
			CLEAN_BUILD=1
		else
			echo

		fi 
	done
}
############################################################
#                         EXECUTION                        #
############################################################
# set correct timezone
sudo ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

#build
check_project

if [ "$CLEAN_BUILD" == "1" ]; then
	build_clean
else
	echo "Doing dirty build"
	build_dirty
fi
