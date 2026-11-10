#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mkimage
PKG_VERSION:=2026-11-09

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/mingrizaizao/u-boot-rockchip.git
PKG_SOURCE_DATE:=2026-11-09
PKG_SOURCE_VERSION:=df329e694d6229b56f82bcdf3c5d5a618311f268
PKG_MIRROR_HASH:=41f63af65c47e2078cea6ee2b68380890e8be9fcae7b92812e895b8fc9967764

PKG_SOURCE_SUBDIR:=u-boot-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR).tar.zst

HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/u-boot-$(PKG_VERSION)

include $(INCLUDE_DIR)/host-build.mk

define Host/Configure
	$(MAKE) -C $(HOST_BUILD_DIR) \
	        HOSTCFLAGS="$(HOST_CFLAGS)" \
	        HOSTLDFLAGS="$(HOST_LDFLAGS)" \
	        PKG_CONFIG_EXTRAARGS="--static" \
	        V=$(if $(findstring c,$(OPENWRT_VERBOSE)),1) \
	        sandbox_defconfig

	python3 -c 'from pathlib import Path; p=Path("$(HOST_BUILD_DIR)/.config"); lines=p.read_text().splitlines(); remove=("CONFIG_RSA_N_SIZE=", "CONFIG_RSA_E_SIZE=", "CONFIG_RSA_C_SIZE="); lines=[x for x in lines if not x.startswith(remove)]; lines=[x for x in lines if x != "CONFIG_RSA=y" and x != "CONFIG_RSA_SOFTWARE_EXP=y"]; lines += ["# CONFIG_RSA is not set", "# CONFIG_RSA_SOFTWARE_EXP is not set", "# CONFIG_FIT_SIGNATURE is not set", "# CONFIG_TOOLS_MKEFICAPSULE is not set"]; p.write_text("\\n".join(lines)+"\\n")'

	$(MAKE) -C $(HOST_BUILD_DIR) olddefconfig
endef

define Host/Compile
	$(MAKE) -C $(HOST_BUILD_DIR) \
		HOSTCFLAGS="$(HOST_CFLAGS)" \
		HOSTLDFLAGS="$(HOST_LDFLAGS)" \
		PKG_CONFIG_EXTRAARGS="--static" \
		V=$(if $(findstring c,$(OPENWRT_VERBOSE)),1) \
		tools-only
endef

define Host/Install
	$(CP) $(HOST_BUILD_DIR)/tools/mkimage $(STAGING_DIR_HOST)/bin/
	$(CP) $(HOST_BUILD_DIR)/tools/mkenvimage $(STAGING_DIR_HOST)/bin/
endef

define Host/Clean
	rm -f $(STAGING_DIR_HOST)/bin/mkimage
	rm -f $(STAGING_DIR_HOST)/bin/mkenvimage
endef

$(eval $(call HostBuild))
