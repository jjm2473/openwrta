#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/zidoo-z9s
  NAME:=Zidoo Z9S
  PACKAGES+=kmod-rtk-emmc kmod-dnsresolver
  DISABLED_SERVICES+=dnsmasq
endef

define Profile/zidoo-z9s/Config
	select RTK_ANDROID
	select PACKAGE_kmod-rtk-emmc
	select PACKAGE_kmod-fs-squashfs
endef

define Profile/zidoo-z9s/Description
	Zidoo Z9S
endef

$(eval $(call Profile,zidoo-z9s))
