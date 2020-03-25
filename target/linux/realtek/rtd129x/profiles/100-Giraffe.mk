#
# Copyright (C) 2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

define Profile/giraffe-spi
  NAME:=Giraffe SPI
  PACKAGES+=kmod-rtk-spi
endef

define Profile/giraffe-spi/Config
	select RTK_BOARD_CHIP_1295
	select PACKAGE_kmod-rtk-spi
endef

define Profile/giraffe-spi/Description
	Giraffe board with SPI NOR flash
endef

$(eval $(call Profile,giraffe-spi))

define Profile/giraffe-nand
  NAME:=Giraffe NAND
  PACKAGES+=kmod-rtk-nand
endef

define Profile/giraffe-nand/Config
	select RTK_BOARD_CHIP_1295
	select PACKAGE_kmod-rtk-nand
endef

define Profile/giraffe-nand/Description
	Giraffe board with NAND flash
endef

#$(eval $(call Profile,giraffe-nand))

define Profile/giraffe-emmc
  NAME:=Giraffe eMMC
  PACKAGES+=kmod-rtk-emmc
endef 

define Profile/giraffe-emmc/Config
	select RTK_ANDROID
	select PACKAGE_kmod-rtk-emmc
	select PACKAGE_kmod-fs-squashfs
endef

define Profile/giraffe-emmc/Description
	Giraffe board with eMMC
endef 

$(eval $(call Profile,giraffe-emmc))
