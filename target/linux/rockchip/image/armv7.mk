# SPDX-License-Identifier: GPL-2.0-only

define Device/rk3128
  SOC := rk3128
  KERNEL_LOADADDR := 0x60008000
endef

define Device/txcz_rk3128-v3-1
  $(Device/rk3128)
  DEVICE_VENDOR := TXCZ
  DEVICE_MODEL := RK3128-V3-1
  DEVICE_DTS := rk3128-xpi-3128
  UBOOT_DEVICE_NAME := txcz-v3-1-rk3128
endef
TARGET_DEVICES += txcz_rk3128-v3-1