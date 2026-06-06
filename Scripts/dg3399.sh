#!/bin/bash

# 获取脚本所在目录的上一级目录
PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DTS_PATH="$PARENT_DIR/dts"
echo "DTS_PATH=$DTS_PATH"

# U-Boot相关
# 复制修改好的uboot/Makefile到对应目录
cp -f $DTS_PATH/uboot-rockchip/Makefile $WRT_PATH/package/boot/uboot-rockchip/Makefile
cat $WRT_PATH/package/boot/uboot-rockchip/Makefile
echo "=============================================================="
# 复制到对应的目录
cp -f $DTS_PATH/uboot-rockchip/dg3399-rk3399_defconfig       $WRT_PATH/package/boot/uboot-rockchip/src/configs/dg3399-rk3399_defconfig
cat $WRT_PATH/package/boot/uboot-rockchip/src/configs/dg3399-rk3399_defconfig
echo "=============================================================="
cp -f $DTS_PATH/uboot-rockchip/rk3399-dg3399-u-boot.dtsi     $WRT_PATH/package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-dg3399-u-boot.dtsi
# mkdir -p $WRT_PATH/package/boot/uboot-rockchip/src/dts/upstream/src/arm64/rockchip
cp -f $DTS_PATH/uboot-rockchip/rk3399-dg3399.dts             $WRT_PATH/package/boot/uboot-rockchip/src/arch/arm/dts/rk3399-dg3399.dts

# 内核相关
cp -f $DTS_PATH/kernel-rockchip/rk3399-dg3399.dts            $WRT_PATH/target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/rk3399-dg3399.dts
cp -f $DTS_PATH/kernel-rockchip/052-v6.19-arm64-dts-rockchip-Add-devicetree-for-the-FriendlyElec-Na.patch            $WRT_PATH/target/linux/rockchip/patches-6.18/052-v6.19-arm64-dts-rockchip-Add-devicetree-for-the-FriendlyElec-Na.patch
echo "=============================================================="
cat $WRT_PATH/target/linux/rockchip/patches-6.18/052-v6.19-arm64-dts-rockchip-Add-devicetree-for-the-FriendlyElec-Na.patch
echo "=============================================================="
# linux/rockchip/image/armv8.mk添加dg3399设备型号
echo -e '
define Device/rockchip_dg3399
  $(Device/rk3399)
  DEVICE_VENDOR := Rockchip
  DEVICE_MODEL := DG3399
  UBOOT_DEVICE_NAME := dg3399-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-ata-ahci kmod-rtl8821ae kmod-usb-net-rtl8152 wpad-openssl \
    brcmfmac-nvram-43455-sdio cypress-firmware-43455-sdio
endef
TARGET_DEVICES += rockchip_dg3399' >> $WRT_PATH/target/linux/rockchip/image/armv8.mk
cat $WRT_PATH/target/linux/rockchip/image/armv8.mk