#
# Copyright (C) 2011-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-init
PKG_RELEASE:=1.0
PKG_LICENSE:=CC0-1.0
PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_FLAGS:=nonshared
include $(INCLUDE_DIR)/package.mk

define Package/rtk-init
  CATEGORY:=Boot Loaders
  SECTION:=boot
  TITLE:=realtek openwrt+android double os init
  MAINTAINER:=jjm2473 <jjm2473@gmail.com>
  DEPENDS:=@TARGET_realtek
endef

define Package/rtk-init/description
 This package contains init program for realtek to boot to openwrt+android double os.
endef

define Build/Configure
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS) -Wall" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define Package/rtk-init/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/init $(1)/etc/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/android.init $(1)/etc/init.d/android
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/10_disable_dnsmasq $(1)/etc/uci-defaults/
endef

$(eval $(call BuildPackage,rtk-init))
