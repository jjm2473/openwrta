#
# Copyright (C) 2012-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dhcp-dns
PKG_RELEASE:=1

PKG_LICENSE:=CC0-1.0
PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

define Package/dhcp-dns
  SECTION:=net
  CATEGORY:=Network
  TITLE:=DHCP client (DNS only)
  DEPENDS:=+netifd +rpcd-mod-file
endef

define Package/dhcp-dns/description
 This package contains DHCP client, that only configure DNS.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/dhcp-dns/install
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/dns.sh $(1)/lib/netifd/proto/dns.sh
	$(INSTALL_BIN) ./files/dns.script $(1)/lib/netifd/
endef

$(eval $(call BuildPackage,dhcp-dns))
