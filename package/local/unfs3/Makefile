
include $(TOPDIR)/rules.mk

PKG_NAME:=unfs3
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/unfs3/unfs3.git
PKG_SOURCE_DATE:=2020-09-03
PKG_SOURCE_VERSION:=428badee4dd1b06a6e624982fb0b02edda8caeac

PKG_FIXUP:=autoreconf

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

PKG_BUILD_DEPENDS:=rpcsvc-proto/host

include $(INCLUDE_DIR)/package.mk

TARGET_CPPFLAGS := \
	-I$(STAGING_DIR)/usr/include/tirpc \
	$(TARGET_CPPFLAGS)

TARGET_CFLAGS := $(TARGET_CPPFLAGS) $(TARGET_CFLAGS)

CONFIGURE_ARGS += LIBS=-ltirpc

define Package/unfs3
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=Filesystem
	TITLE:=Userspace NFSv3 server
	DEPENDS:=+libtirpc +rpcbind
	URL:=$(PKG_SOURCE_URL)
	CONFLICTS:=nfs-kernel-server
endef

define Package/unfs3/description
	UNFS3 is a user-space implementation of the NFSv3 server specification.
endef

define Package/unfs3/conffiles
/etc/exports
endef

define Package/unfs3/install
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/usr/sbin
	$(INSTALL_DATA) ./files/nfsd.exports $(1)/etc/exports
	$(INSTALL_BIN) ./files/nfsd.init $(1)/etc/init.d/nfsd
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/unfsd $(1)/usr/sbin/unfsd
endef

$(eval $(call BuildPackage,unfs3))
