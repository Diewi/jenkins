#!/bin/sh

################################################################################
# BUILD SCRIPT
#
# Launch the script only
#
# ${1}: device codename (e.g. sirius)
# ${2}: device identifier (e.g. d6503). Launch 'lunch' without parameters to see
#       a list of all identifiers.
################################################################################

export BASE_DIR=omni

export USE_CCACHE=1
export CCACHE_DIR=/mnt/android/ccache
export OUT_DIR_COMMON_BASE=/mnt/android/output
export OUT_DEVICE="${OUT_DIR_COMMON_BASE}/${BASE_DIR}/target/product/${1}"


source build/envsetup.sh

# Cleanup steps to trigger re-copying of files. The make system handles source
# file changes.
rm -rf ${OUT_DEVICE}/cache
rm -rf ${OUT_DEVICE}/data
rm -rf ${OUT_DEVICE}/recovery
rm -rf ${OUT_DEVICE}/root
rm -rf ${OUT_DEVICE}/system
rm -rf ${OUT_DEVICE}/*.zip
rm -rf "${OUT_DIR_COMMON_BASE}/${BASE_DIR}"/dist/*

# Configure the env for the device
if [ "$#" -eq 3 ]; then
	echo "!!!! Using lunch !!!!"
	export ROM_BUILDTYPE=${3}
	brunch ${1}${2}
	#make -j3 otapackage
else
	echo " !!!! Using breakfast !!!! "
	breakfast omni_${1}${2}
	make -j3 ${4}
fi

# Run the build to produce an installable update zip file
#make -j3 ${1}

