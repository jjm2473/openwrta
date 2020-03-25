#
# Copyright (C) 2006-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-android-kmods
PKG_VERSION:=$(call qstrip,$(CONFIG_RTK_ANDROID_KMOD_VERSION))
PKG_RELEASE:=1
PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>

PKG_SOURCE:=kmod-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/jjm2473/realtek-android-kmod/releases/download/V$(PKG_VERSION)/
ifeq ("$(PKG_VERSION)","4.1.35-04005-g6c2818e-dirty")
	PKG_HASH:=583c184bf0b41fff38b1784b3d49d42e4c684feffc23cfaeb5ecf19589647266
else
    # 4.1.17-g9100299-dirty
	PKG_HASH:=94478ac5b37e44f396e71d7160b72eb5454bad5cd94446c430bac31a585751d0
endif

PKG_FLAGS:=hold essential nonshared
include $(INCLUDE_DIR)/package.mk

define Package/rtk-android-kmods
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Realtek android kmods
  DEPENDS:=@TARGET_realtek @RTK_ANDROID +base-files
  ABI_VERSION:=$(PKG_VERSION)
endef

define Download/rtk-android-kmods
	$(eval $(Download/default))
endef

define Build/Prepare
	# Download sources
	$(eval $(call Download,rtk-android-kmods))

	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	$(TAR) -C $(PKG_BUILD_DIR) -xmf $(DL_DIR)/$(PKG_SOURCE)
endef

define Build/Compile/Default
endef
Build/Compile = $(Build/Compile/Default)

define Package/rtk-android-kmods/preinst
	#!/bin/sh
	[ -z "$${IPKG_INSTROOT}" ] && exit 0
	
	rm -rf "$${IPKG_INSTROOT}/lib/modules" && \
	rm -rf "$${IPKG_INSTROOT}/etc/modules.d" && \
	rm -rf "$${IPKG_INSTROOT}/etc/modules-boot.d"
endef

define Package/rtk-android-kmods/install
	$(INSTALL_DIR) $(1)/lib/modules
	$(INSTALL_DIR) $(1)/etc
	$(CP) -a $(PKG_BUILD_DIR)/$(PKG_VERSION) $(1)/lib/modules/
	$(CP) -a $(PKG_BUILD_DIR)/modules.d $(1)/etc/
	$(CP) -a $(PKG_BUILD_DIR)/modules-boot.d $(1)/etc/
endef

$(eval $(call BuildPackage,rtk-android-kmods))
