include $(TOPDIR)/rules.mk

PKG_NAME:=transmission-web-control-over
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/ronggang/transmission-web-control
PKG_SOURCE_DATE:=2019-07-24
PKG_SOURCE_VERSION:=c27e3ba9f08148f79fb4121d8a1f5906640ff8d6
PKG_MIRROR_HASH:=6de823b9b8229b176fbb5c9f33f326c0fb23553ae00a36f60d019fdcdf90a712

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Richard Yu <yurichard3839@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/transmission-web-control-over
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=BitTorrent
  DEPENDS:=@(PACKAGE_transmission-daemon-openssl||PACKAGE_transmission-daemon-mbedtls) +transmission-web
  CONFLICTS:=transmission-web-control
  TITLE:=ronggang's Transmission Web Control with original UI
  URL:=https://github.com/ronggang/transmission-web-control
  PKGARCH:=all
endef

define Package/transmission-web-control-over/description
 Transmission Web Control is a custom Web UI for Transmission.
endef

define Build/Compile
endef

define Package/transmission-web-control-over/install
	$(INSTALL_DIR) $(1)/usr/share/transmission/web
	$(CP) $(PKG_BUILD_DIR)/src/* $(1)/usr/share/transmission/web
	mv $(1)/usr/share/transmission/web/index.html $(1)/usr/share/transmission/web/index.new.html
endef

define Package/transmission-web-control-over/postinst
#!/bin/sh
[ -f /usr/share/transmission/web/index.original.html ] || mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html
[ -f /usr/share/transmission/web/index.html ] && rm -f /usr/share/transmission/web/index.html
mv /usr/share/transmission/web/index.new.html /usr/share/transmission/web/index.html
endef

define Package/transmission-web-control-over/prerm
#!/bin/sh
mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.new.html
mv /usr/share/transmission/web/index.original.html /usr/share/transmission/web/index.html
endef

$(eval $(call BuildPackage,transmission-web-control-over))