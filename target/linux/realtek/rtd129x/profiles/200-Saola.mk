#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/saola-spi
  NAME:=Saola SPI
  PACKAGES+=kmod-rtk-spi
endef

define Profile/saola-spi/Config
	select RTK_BOARD_CHIP_1296
	select PACKAGE_kmod-rtk-spi
endef

define Profile/saola-spi/Description
	Saola board with SPI NOR flash
endef

$(eval $(call Profile,saola-spi))

define Profile/saola-nand
  NAME:=Saola NAND
  PACKAGES+=kmod-rtk-nand
endef

define Profile/saola-nand/Config
	select RTK_BOARD_CHIP_1296
	select PACKAGE_kmod-rtk-nand
endef

define Profile/saola-nand/Description
	Saola board with NAND flash
endef

#$(eval $(call Profile,saola-nand))

define Profile/saola-emmc
  NAME:=Saola eMMC
  PACKAGES+=kmod-rtk-emmc
endef

define Profile/saola-emmc/Config
	select RTK_ANDROID
	select PACKAGE_kmod-rtk-emmc
	select PACKAGE_kmod-fs-squashfs
endef

define Profile/saola-emmc/Description
	Saola board with eMMC
endef

$(eval $(call Profile,saola-emmc))
