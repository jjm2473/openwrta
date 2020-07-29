#!/bin/sh

PRG_DIR=`dirname $0`
PRG_DIR=`sh -c "cd $PRG_DIR && pwd"`

ROOT_FS=${1:-rootfs.img}
TEMPLATE_ZIP=$PRG_DIR/flash_op.zip
DIST_FILE=${2:-OTA.zip}
TMP_PREFIX=/tmp/flash_op_build_`date +%s`-$RANDOM
IMG_FILE=$TMP_PREFIX/squashfs1.img
OTA_FILE=$TMP_PREFIX/ota.zip
SIGNED_OTA_FILE=$TMP_PREFIX/ota.signed.zip

build() {
    mkdir -p $TMP_PREFIX || return 1
    [ -f $IMG_FILE ] && (rm -f $IMG_FILE || return 1)
    cp $ROOT_FS $IMG_FILE || return 1
    cp $TEMPLATE_ZIP $OTA_FILE || return 1
    sh -c "cd $TMP_PREFIX && zip $OTA_FILE squashfs1.img" || return 1
    $PRG_DIR/signrom testkey $OTA_FILE $SIGNED_OTA_FILE || return 1
    mv $SIGNED_OTA_FILE $DIST_FILE
}

clean() {
    rm -rf $TMP_PREFIX
}

build
RET=$?

clean

exit $RET