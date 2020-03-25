#
# Copyright (C) 2012-2020 OpenWrt.org
# Copyright (C) 2017 LEDE project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

ARCH:=aarch64
BOARD:=realtek
BOARDNAME:=Realtek SoC
FEATURES:=usb usbgadget gpio fpu squashfs
MAINTAINER:=JJm2473 <jjm2473@gmail.com>
SUBTARGETS:=rtd129x

KERNEL_PATCHVER:=4.19
KERNEL_TESTING_PATCHVER=5.4

define Target/Description
	Build firmware image for Realtek SoC.
endef

include $(INCLUDE_DIR)/target.mk
DEFAULT_PACKAGES += \
	bash blkid blockdev block-mount ca-bundle curl libustream-mbedtls partx-utils mkf2fs e2fsprogs

KERNELNAME:=Image dtbs

$(eval $(call BuildTarget))
