# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += UBOOT_DEVICE_NAME

define Build/Compile
	$(CP) $(LINUX_DIR)/COPYING $(KDIR)/COPYING.linux
endef

### Image scripts ###
define Build/boot-common
	# This creates a new folder copies the dtb (as rockchip.dtb) 
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
	$(CP) $(KDIR)/image-$(firstword $(DEVICE_DTS)).dtb $@.boot/rk3128.dtb
endef

define Build/boot-script
	# Make an U-boot image and copy it to the boot partition
	mkimage -A arm -O linux -T script -C none -a 0 -e 0 -d $(if $(1),$(1),default).bootscript $@.boot/boot.scr
endef

# RK3128: package Rockchip SD/MMC idbloader
define Build/rk3128-idbloader
    set -e; \
    work="$@.work"; \
    trap 'rm -rf "$$work"' EXIT; \
    rm -rf "$$work"; \
    mkdir -p "$$work"; \
    "$(STAGING_DIR_IMAGE)/rkbin/tools/mkimage" \
        -n rk3128 -T rksd \
        -d "$(STAGING_DIR_IMAGE)/rkbin/bin/rk31/rk3128_ddr_300MHz_v2.12.bin" \
        "$$work/idbloader-ddr.img"; \
    cat "$(STAGING_DIR_IMAGE)/rkbin/bin/rk31/rk3128x_miniloader_v2.57.bin" \
        >> "$$work/idbloader-ddr.img"; \
    cp "$$work/idbloader-ddr.img" "$@"
endef

# RK3128: package Rockchip miniloader
define Build/rk3128-loader
	set -e; \
	work="$@.work"; \
	trap 'rm -rf "$$work"' EXIT; \
	rm -rf "$$work"; \
	mkdir -p "$$work"; \
	cp -a "$(STAGING_DIR_IMAGE)/rkbin/." "$$work/"; \
	(cd "$$work" && ./tools/boot_merger ./RKBOOT/RK3128MINIALL.ini); \
	cp "$$work/rk3128_loader_v2.12.263.bin" "$@"
endef

# RK3128: package U-Boot
define Build/rk3128-uboot
	$(STAGING_DIR_IMAGE)/rkbin/tools/loaderimage \
		--pack --uboot \
		$(STAGING_DIR_IMAGE)/txcz-rk3128-v3-1-u-boot.bin \
		"$@" 0x60000000
endef

# RK3128: package Trust firmware
define Build/rk3128-trust
	$(STAGING_DIR_IMAGE)/rkbin/tools/loaderimage \
		--pack --trustos \
		$(STAGING_DIR_IMAGE)/rkbin/bin/rk31/rk3126_tee_ta_v2.04.bin \
		"$@" --size 1024 4
endef

define Build/pine64-img
	# Creates the final SD/eMMC images, 
	# combining boot partition, root partition as well as the u-boot bootloader

	# Generate a new partition table in $@ with 32 MiB of 
	# alignment padding for the u-boot-rockchip.bin (idbloader + u-boot) to fit:
	# http://opensource.rock-chips.com/wiki_Boot_option#Boot_flow
	#
	# U-Boot SPL expects the U-Boot ITB to be located at sector 0x4000 (8 MiB) on the MMC storage
	PADDING=1 $(SCRIPT_DIR)/gen_image_generic.sh \
		$@ \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		32768

	# Copy the u-boot-rockchip.bin to the image at sector 0x40
	dd if="$(STAGING_DIR_IMAGE)"/$(UBOOT_DEVICE_NAME)-u-boot-rockchip.bin of="$@" seek=64 conv=notrunc
endef

define Build/rk3128-img
        set -e; \
        PADDING=1 PARTOFFSET=16M $(SCRIPT_DIR)/gen_image_generic.sh \
                $@ \
                $(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
                $(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
                1024; \
        dd if="$(BIN_DIR)/$(DEVICE_IMG_PREFIX)-idbloader.img" \
                of="$@" bs=512 seek=64 conv=notrunc; \
        dd if="$(BIN_DIR)/$(DEVICE_IMG_PREFIX)-uboot.img" \
                of="$@" bs=512 seek=16384 conv=notrunc; \
        dd if="$(BIN_DIR)/$(DEVICE_IMG_PREFIX)-trust.img" \
                of="$@" bs=512 seek=24576 conv=notrunc
endef

### Devices ###
define Device/Default
  PROFILES := Default
  KERNEL = kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  KERNEL_LOADADDR :=
  BOOT_SCRIPT :=
  IMAGES := sysupgrade.img.gz
  IMAGE/sysupgrade.img.gz = boot-common | boot-script $$(BOOT_SCRIPT) | pine64-img | gzip | append-metadata
  DEVICE_DTS_DIR = $$(DTS_DIR)/rockchip
  DEVICE_DTS = $$(SOC)-$(lastword $(subst _, ,$(1)))
  UBOOT_DEVICE_NAME = $(lastword $(subst _, ,$(1)))-$$(SOC)
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
