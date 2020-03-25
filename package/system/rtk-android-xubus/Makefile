#
# Copyright (C) 2011-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-android-xubus
PKG_RELEASE:=1.0
PKG_LICENSE:=CC0-1.0
PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_FLAGS:=nonshared
include $(INCLUDE_DIR)/package.mk

define Package/rtk-android-xubus
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Realtek openwrt ubus bridge for android
  MAINTAINER:=jjm2473 <jjm2473@gmail.com>
  DEPENDS:=@TARGET_realtek @RTK_ANDROID +base-files
endef

define Package/rtk-android-xubus/description
 This package contains ubus proxy program for realtek android to RPC openwrt.
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -Wall" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Package/rtk-android-xubus/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/xubus $(1)/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/xubus.init $(1)/etc/init.d/xubus
endef

$(eval $(call BuildPackage,rtk-android-xubus))
