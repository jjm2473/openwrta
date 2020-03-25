#
# Copyright (C) 2016-2017 Yousong Zhou <yszhou4tech@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Image/Build/ota/squashfs
	./android/mkota.sh $(BIN_DIR)/$(IMG_ROOTFS)-squashfs.img $(BIN_DIR)/$(IMG_ROOTFS).ota.zip
endef

define Image/Build
	$(call Image/Build/$(1))
	$(CP) $(KDIR)/root.$(1) $(BIN_DIR)/$(IMG_ROOTFS)-$(1).img
	$(call Image/Build/ota/$(1))
endef

$(eval $(call BuildImage))
