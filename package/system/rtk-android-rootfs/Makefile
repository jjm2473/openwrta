#
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-android-rootfs
PKG_VERSION:=$(call qstrip,$(CONFIG_RTK_ANDROID_VERSION))
PKG_RELEASE:=1
PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>

PKG_SOURCE:=android-$(PKG_VERSION)-$(PKG_RELEASE).tar.gz
PKG_SOURCE_URL:=https://github.com/jjm2473/realtek-android-rootfs/releases/download/$(PKG_VERSION)-V$(PKG_RELEASE)/
ifeq ("$(PKG_VERSION)","7.1.1")
	PKG_HASH:=fdd9dc2f4ec74b1dfec3f6e30bcf1cf21202b55945f34000055ccb160de6fea1
else
	PKG_HASH:=0132f376380b1a9743a23b1366230f28cf49918292c1d064df34bfd5534d72b6
endif

PKG_FLAGS:=hold essential nonshared
include $(INCLUDE_DIR)/package.mk

define Package/rtk-android-rootfs
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Realtek android rootfs
  DEPENDS:=@TARGET_realtek @RTK_ANDROID +base-files
  ABI_VERSION:=$(PKG_VERSION)
endef

define Download/rtk-android-rootfs
	$(eval $(Download/default))
endef

define Build/Prepare
	# Download sources
	$(eval $(call Download,rtk-android-rootfs))

	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) -C $(PKG_BUILD_DIR) -xmf $(DL_DIR)/$(PKG_SOURCE)
endef

define Build/Compile/Default
endef
Build/Compile = $(Build/Compile/Default)

define Package/rtk-android-rootfs/install
	$(INSTALL_DIR) $(1)/android
	$(INSTALL_DIR) $(1)/mnt
	$(CP) -a $(PKG_BUILD_DIR)/android $(1)/mnt/
endef

$(eval $(call BuildPackage,rtk-android-rootfs))
