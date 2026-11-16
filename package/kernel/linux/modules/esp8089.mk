define KernelPackage/esp8089
  SUBMENU:=$(OTHER_MENU)
  TITLE:=Espressif ESP8089 SDIO WiFi driver
  DEPENDS:=@TARGET_rockchip
  KCONFIG:=CONFIG_ESP8089
  FILES:=$(LINUX_DIR)/drivers/net/wireless/esp8089/esp8089.ko
  AUTOLOAD:=$(call AutoProbe,esp8089)
endef

define KernelPackage/esp8089/description
  Kernel module for Espressif ESP8089 SDIO wireless devices.
endef

$(eval $(call KernelPackage,esp8089))
