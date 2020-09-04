# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for nfs
LUCI_DEPENDS:=@(PACKAGE_nfs-kernel-server||PACKAGE_unfs3) +nfs-utils +mount-utils
LUCI_PKGARCH:=all
PKG_VERSION:=1.2
PKG_RELEASE:=1

define Package/luci-app-nfs/conffiles
/etc/config/nfs
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature

