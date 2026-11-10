# SPDX-License-Identifier: GPL-2.0-only

define Device/rk3128
  SOC := rk3128
  KERNEL_LOADADDR := 0x60008000
endef

define Device/txcz_rk3128-v3-1
  $(Device/rk3128)
  DEVICE_VENDOR := TXCZ
  DEVICE_MODEL := RK3128-V3-1
  DEVICE_DTS := rk3128-txcz-rk3128-v3-1
  UBOOT_DEVICE_NAME := txcz-rk3128-v3-1

  # Do not inherit the default Pine64 sysupgrade image
  IMAGES := sysupgrade.img.gz
  IMAGE/sysupgrade.img.gz = boot-common | boot-script $$(BOOT_SCRIPT) | rk3128-img | gzip | append-metadata

  # RK3128 boot artifacts
  ARTIFACTS := idbloader.img rk3128_loader_v2.12.263.bin uboot.img trust.img

  # Allow bootloader artifacts to build before the main image
  ARTIFACT_SKIP_IMAGE_DEPENDS := 1

  # Main image must wait for the three bootloader artifacts
  IMAGE_DEPENDS := \
    $(BIN_DIR)/$(IMG_PREFIX)-txcz_rk3128-v3-1-idbloader.img \
    $(BIN_DIR)/$(IMG_PREFIX)-txcz_rk3128-v3-1-uboot.img \
    $(BIN_DIR)/$(IMG_PREFIX)-txcz_rk3128-v3-1-trust.img

  ARTIFACT/idbloader.img := rk3128-idbloader
  ARTIFACT/rk3128_loader_v2.12.263.bin := rk3128-loader
  ARTIFACT/uboot.img := rk3128-uboot
  ARTIFACT/trust.img := rk3128-trust
endef

TARGET_DEVICES += txcz_rk3128-v3-1