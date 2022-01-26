#!/bin/bash

ENV_SOURCE_TAR=/media/ROSA/MTK_R0MP1.tar.gz
ROOT_DIR=MTK_R0MP1
KERNEL_DIR=kernel-4.14
LK_DIR=vendor/mediatek/proprietary/bootable/bootloader/lk

# Repository used in rosalinux
KERNEL_REPO=git@github.com:rosalinux/linux-4.14.189_mtk_android.git
LK_REPO=git@github.com:rosalinux/ayya-lk.git

# Repository brunch used in rosalinux
BRUNCH=openmandriva

# Select build variant (user, userdebug, eng)
BUILD_VARIANT=user

# Number build threads
BUILD_THREADS=15

# Text echo params
NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'

function environment_setup() {
    source build/envsetup.sh
    lunch full_k71v1_64_bsp-${BUILD_VARIANT}
}

function check_directory_exist() {
    if [ -d $1 ]
    then
	echo "Directory '$1' already exists. Delete?"
	select yn in "Yes" "No"; do
	    case $yn in
		Yes )
		    echo "Deleting '$1'"
		    rm -rf $1
		    break;;
		No )
		    echo "Exit without actions"
		    exit;;
	    esac
	done
    fi
}

unpack() {
	check_directory_exist ${ROOT_DIR}

	tar -xvf ${ENV_SOURCE_TAR}
}

clone() {
	case $1 in
	kernel)
		echo "Clone kernel"
		SOURCE_DIR="$ROOT_DIR/$KERNEL_DIR"
		REPO="${KERNEL_REPO}"
		;;
	lk)
		echo "Clone lk"
		SOURCE_DIR="$ROOT_DIR/$LK_DIR"
		REPO="${LK_REPO}"
		;;
	*)
		echo "Unknown download argument"
		usage
		exit
		;;
	esac

	check_directory_exist ${SOURCE_DIR}

	echo "${BRUNCH} ${REPO} ${SOURCE_DIR}"

	git clone -b ${BRUNCH} ${REPO} ${SOURCE_DIR}
}

build() {
	case $1 in
	kernel)
		echo "Build kernel"
		if ! [ -d $ROOT_DIR/$KERNEL_DIR ]; then
			echo "Kernal source code is not cloned"
			usage
			exit
		fi
		BUILD_TARGET="bootimage"
		;;
	lk)
		echo "Build lk"
		if ! [ -d $ROOT_DIR/$LK_DIR ]; then
			echo "lk source code is not cloned"
			usage
			exit
		fi
		BUILD_TARGET="lk.img"
		;;
	*)
		echo "Unknown build argument"
		usage
		exit
		;;
	esac

	cd $ROOT_DIR
	environment_setup
	make -j ${BUILD_THREADS} ${BUILD_TARGET}
	cd ..
}

check_valid_variant() {
	case ${BUILD_VARIANT} in
	user|userdebug|eng)
		;;
	*)
		echo "${BUILD_VARIANT} is invalid build variant"
		usage
		exit
		;;
	esac
}

usage() {
    echo -e "${RED} Usage: $0 ${NORMAL}"
    echo -e "${GREEN} -b: Build option : use arguments - kernel, lk ${NORMAL}"
    echo -e "${GREEN} -c: Clone source code from rosalinux repository : use arguments - kernel, lk ${NORMAL}"
    echo -e "${GREEN} -j: Set number of build threads - default is 15 ${NORMAL}"
    echo -e "${GREEN} -u: Unpack archive with environment source tarball) ${NORMAL}"
    echo -e "${GREEN} -v: Set build variant option : use arguments - user, userdebug, eng - default is user ${NORMAL}"
    echo -e "${GREEN} -h: Help in use ${NORMAL}"
    echo -e "${YELLOW} Example usage: $0 -u -c kernel -c lk -b kernel -j 10 -v userdebug ${NORMAL}"
    echo -e "${YELLOW} This example unpacks archive, clones kernel and lk repositories, sets number of build threads = 10, ${NORMAL}"
    echo -e "${YELLOW} sets build variant to userdebug and builds kernel. ${NORMAL}"
}

UNPACK_OPTARGS="false"
BUILD_OPTARGS=""
CLONE_OPTARGS=""

while getopts "b:c:hj:uv:" opt; do
	case $opt in
	b)
		BUILD_OPTARGS="${BUILD_OPTARGS} $OPTARG"
		;;
	c)
		CLONE_OPTARGS="${CLONE_OPTARGS} $OPTARG"
		;;
	j)
		echo "Set number of build threads: $OPTARG"
		BUILD_THREADS="$OPTARG"
		;;
	u)
		UNPACK_OPTARGS="true"
		;;
	v)
		echo "Set build variant: $OPTARG"
		BUILD_VARIANT="$OPTARG"
		check_valid_variant
		;;
	h)
		usage
		exit 1
		;;
	*)
		echo "Unknown option $opt" >&2
		usage
		exit 1
		;;
	esac
done

# Unpack
if [ ${UNPACK_OPTARGS} = "true" ]; then
	unpack
fi

# Clone
for i in $CLONE_OPTARGS; do
	clone ${i}
done

# Build
for i in $BUILD_OPTARGS; do
	build ${i}
done

