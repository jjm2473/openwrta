#
# Copyright (C) 2016-2017 Yousong Zhou <yszhou4tech@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Build/realtek-ota
	./android/mkota.sh $(IMAGE_ROOTFS) $@
endef

ifeq ($(SUBTARGET),rtd129x)

define Device/Default
	PROFILES = $$(DEVICE_NAME)
	IMAGE_NAME = $$(IMAGE_PREFIX)-$$(1).$$(2)
	FILESYSTEMS := squashfs
	IMAGES := ota.zip
	IMAGE/ota.zip := realtek-ota
endef

define Device/zidoo-x9s
	PROFILES = zidoo-x9s
	DEVICE_PACKAGES := rtk-init rtk-android-rootfs rtk-android-kmods rtk-android-xubus
endef
TARGET_DEVICES += zidoo-x9s

define Device/zidoo-z9s
	PROFILES = zidoo-z9s
	DEVICE_PACKAGES := rtk-init rtk-android-rootfs rtk-android-kmods rtk-android-xubus
endef
TARGET_DEVICES += zidoo-z9s

endif

$(eval $(call BuildImage))
