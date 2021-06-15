#
# Copyright (C) 2016-2017 Yousong Zhou <yszhou4tech@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Build/realtek-ota
	dd if=$(IMAGE_ROOTFS) of=$(IMAGE_ROOTFS).padded bs=4096 conv=sync
	./android/mkota.sh $(IMAGE_ROOTFS).padded $@
endef

ifeq ($(SUBTARGET),rtd129x)

define Device/Default
	KERNEL := kernel-bin
	PROFILES = $$(DEVICE_NAME)
	IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
	FILESYSTEMS := squashfs
	IMAGES := ota.zip
	IMAGE/ota.zip := realtek-ota
	DEVICE_PACKAGES := rtk-init rtk-android-rootfs rtk-android-kmods rtk-android-xubus
endef

define Device/zidoo-x9s
	$(call Device/Default)
	PROFILES = zidoo-x9s
endef
TARGET_DEVICES += zidoo-x9s

define Device/zidoo-z9s
	$(call Device/Default)
	PROFILES = zidoo-z9s
endef
TARGET_DEVICES += zidoo-z9s

SQUASHFSCOMP := xz

endif

$(eval $(call BuildImage))
