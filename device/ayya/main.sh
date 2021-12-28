#!/bin/bash

SOURCE_DIR=/media/ROSA
ROOT_DIR=MTK_R0MP1
KERNEL_DIR=kernel-4.14
LK_DIR=vendor/mediatek/proprietary/bootable/bootloader/lk

function environment_setup() {
    source build/envsetup.sh
    lunch full_k71v1_64_bsp-user
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

case $1 in
    unpack)
	tar -xvf $SOURCE_DIR/MTK_R0MP1.tar.gz
	;;
    download_kernel)
	check_directory_exist "$ROOT_DIR/$KERNEL_DIR"
	git clone -b openmandriva git@github.com:rosalinux/linux-4.14.189_mtk_android.git $ROOT_DIR/$KERNEL_DIR
	;;
    download_lk)
	check_directory_exist "$ROOT_DIR/$LK_DIR"
	git clone -b openmandriva git@github.com:rosalinux/ayya-lk.git $ROOT_DIR/$LK_DIR
	;;
    build_kernel)
	cd $ROOT_DIR
	environment_setup
	make -j 15 bootimage
	cd ..
	;;
    build_lk)
	cd $ROOT_DIR
	environment_setup
	make -j 15 lk.img
	cd ..
	;;
    *)
	echo "Unknown option, use unpack, download_kernel, donwload_lk, build_kernel or build_lk"
	;;
esac