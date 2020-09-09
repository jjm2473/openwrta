include $(TOPDIR)/rules.mk

PKG_NAME:=zstd
PKG_VERSION:=1.4.5
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/facebook/zstd/releases/download/v$(PKG_VERSION)
PKG_HASH:=98e91c7c6bf162bf90e4e70fdbc41a8188b9fa8de5ad840c401198014406ce9e

PKG_MAINTAINER:=
PKG_LICENSE:=GPL-2.0-or-later
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1
CMAKE_INSTALL:=1

CMAKE_SOURCE_SUBDIR:=build/cmake
CMAKE_BINARY_SUBDIR:=build/cmake/build

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/zstd/Default
  SUBMENU:=Compression
  URL:=https://github.com/facebook/zstd
endef

define Package/libzstd
$(call Package/zstd/Default)
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=zstd library.
  MENU:=1
endef

define Package/libzstd/description
  Zstandard - Fast real-time compression algorithm.
  This package provides libzstd library.
endef

define Package/libzstd/config
	config ZSTD_OPTIMIZE_O3
		bool "Use all optimizations (-O3)"
		depends on PACKAGE_libzstd
		default y
		help
			This enables additional optmizations using the -O3 compilation flag.
endef

define Package/zstd
$(call Package/zstd/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+libzstd
  TITLE:=Fast real-time compression algorithm.
endef

define Package/zstd/description
  Zstandard - Fast real-time compression algorithm.
  This package provides the zstd binaries.
endef

ifeq ($(CONFIG_ZSTD_OPTIMIZE_O3),y)
TARGET_CFLAGS:= $(filter-out -O%,$(TARGET_CFLAGS)) -O3
endif

TARGET_CFLAGS += $(if $(CONFIG_USE_UCLIBC),-D_BSD_SOURCE)

CMAKE_OPTIONS += \
	-DZSTD_PROGRAMS_LINK_SHARED:BOOL=ON \
	-DZSTD_BUILD_SHARED:BOOL=ON \
	-DZSTD_BUILD_CONTRIB:BOOL=OFF \
	-DZSTD_BUILD_STATIC:BOOL=OFF \
	-DZSTD_BUILD_TESTS:BOOL=OFF \
	-DZSTD_ZLIB_SUPPORT:BOOL=OFF \
	-DZSTD_LZMA_SUPPORT:BOOL=OFF \
	-DZSTD_LZ4_SUPPORT:BOOL=OFF \
	-DCMAKE_BUILD_TYPE=Release

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/*.h $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libzstd.so* $(1)/usr/lib
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libzstd.pc $(1)/usr/lib/pkgconfig
endef

define Package/libzstd/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libzstd.so* $(1)/usr/lib
endef

define Package/zstd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/{unzstd,zstd,zstdcat,zstdgrep,zstdless,zstdmt} $(1)/usr/bin
endef

$(eval $(call BuildPackage,libzstd))
$(eval $(call BuildPackage,zstd))
