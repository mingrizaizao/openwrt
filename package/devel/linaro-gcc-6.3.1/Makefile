include $(TOPDIR)/rules.mk

PKG_NAME:=linaro-gcc
PKG_VERSION:=6.3.1
PKG_RELEASE:=1

PKG_SOURCE:=gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
PKG_SOURCE_URL:=https://github.com/mingrizaizao/rk3128-toolchains/releases/download/1.0.0
PKG_HASH:=926b791cd689e8573c3cd912d10e30b7d12a08bb16b9b9eaf598e2074052dc5f

PKG_HOST_ONLY:=1
PKG_BUILD_DIR:=$(BUILD_DIR_HOST)/linaro-gcc-$(PKG_VERSION)
HOST_BUILD_DIR:=$(BUILD_DIR_HOST)/linaro-gcc-$(PKG_VERSION)
HOST_BUILD_PREFIX:=$(STAGING_DIR_HOST)
HOST_INSTALL_DIR:=$(STAGING_DIR_HOST)/linaro-gcc-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/linaro-gcc
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=Linaro GCC 6.3.1 ARM hard-float toolchain
  BUILDONLY:=1
endef

define Host/Compile
	@echo "Prebuilt Linaro GCC toolchain: no compilation required"
endef

define Host/Install
	mkdir -p $(HOST_INSTALL_DIR)
	$(CP) $(HOST_BUILD_DIR)/../gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/* $(HOST_INSTALL_DIR)/
endef

define Host/Clean
	rm -rf $(HOST_INSTALL_DIR)
endef

$(eval $(call BuildPackage,linaro-gcc))
$(eval $(call HostBuild))