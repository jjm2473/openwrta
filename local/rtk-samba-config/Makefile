#
# Copyright (C) 2011-2012 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtk-samba-config
PKG_RELEASE:=1.0
PKG_LICENSE:=CC0-1.0
PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

PKG_FLAGS:=nonshared
include $(INCLUDE_DIR)/package.mk

define Package/rtk-samba-config
  SECTION:=net
  CATEGORY:=Network
  TITLE:=realtek samba config
  MAINTAINER:=jjm2473 <jjm2473@gmail.com>
  DEPENDS:=@TARGET_realtek @(PACKAGE_samba36-server||PACKAGE_samba4-server) +PACKAGE_samba36-server:samba36-server +PACKAGE_samba4-server:samba4-server
endef

define Package/rtk-samba-config/description
 This package will set samba 'bind interfaces only' to 'no'
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/rtk-samba-config/postinst
#!/bin/sh
cd $${IPKG_INSTROOT}/etc/samba
sed -ie 's/bind interfaces only.*/bind interfaces only = no/g' smb.conf.template
endef

define Package/rtk-samba-config/prerm
#!/bin/sh
cd $${IPKG_INSTROOT}/etc/samba
sed -ie 's/bind interfaces only.*/bind interfaces only = yes/g' smb.conf.template
endef

$(eval $(call BuildPackage,rtk-samba-config))
