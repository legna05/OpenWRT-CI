#!/bin/bash

# 获取脚本所在目录的上一级目录
PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "PARENT_DIR=$PARENT_DIR"

# 设置目标目录（默认位置）
GOLANG_DIR="$PARENT_DIR/wrt/feeds/packages/lang/golang"
echo "GOLANG_DIR=$GOLANG_DIR"

# 检查目录是否存在，如果存在则删除
if [ -d "$GOLANG_DIR" ]; then
    echo "发现已存在的golang目录，正在删除..."
    rm -rf "$GOLANG_DIR"

    # 检查删除是否成功
    if [ $? -eq 0 ]; then
        echo "✓ 目录删除成功"
    else
        echo "✗ 目录删除失败，可能权限不足"
        exit 1
    fi
else
    echo "golang目录不存在，无需删除"
fi

# 克隆新的golang包
echo "正在克隆golang包到: $GOLANG_DIR"
git clone https://github.com/sbwml/packages_lang_golang -b 26.x "$GOLANG_DIR"

# 检查克隆是否成功
if [ $? -eq 0 ]; then
    echo "golang包替换成功！"

    # 显示克隆后的目录结构
    echo "克隆完成后的目录："
    ls -la "$GOLANG_DIR"
else
    echo "golang包替换失败，请检查网络或仓库地址"
    exit 1
fi

# TTYD 免登录
sed -i 's|/bin/login|/bin/login -f root|g' $PARENT_DIR/wrt/feeds/packages/utils/ttyd/files/ttyd.config

# Set the default password for the 'root' user (change empty password to 'password')
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' $PARENT_DIR/wrt/package/base-files/files/etc/shadow

# netspeedtest
netspeedtest_path="$PARENT_DIR/wrt/package/luci-app-netspeedtest"
git clone --depth 1 --branch master --single-branch --no-checkout https://github.com/muink/luci-app-netspeedtest.git $netspeedtest_path
pushd $netspeedtest_path
umask 022
git checkout
popd

# 定义目标文件路径（修改为实际路径）
package_path="$PARENT_DIR/wrt/package"

# diskman安装
mkdir -p $package_path/luci-app-diskman
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile -O $package_path/luci-app-diskman/Makefile
mkdir -p $package_path/parted
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O $package_path/parted/Makefile

install_smartdns() {
    echo "安装 SmartDNS"
    local WORKINGDIR="$PARENT_DIR/wrt/feeds/packages/net/smartdns"
    mkdir -p "$WORKINGDIR"
    rm -rf "$WORKINGDIR"/*

    wget -q https://github.com/pymumu/openwrt-smartdns/archive/master.zip -O "$WORKINGDIR/master.zip"
    unzip -q "$WORKINGDIR/master.zip" -d "$WORKINGDIR"
    mv "$WORKINGDIR/openwrt-smartdns-master/"* "$WORKINGDIR/"
    rmdir "$WORKINGDIR/openwrt-smartdns-master"
    rm "$WORKINGDIR/master.zip"
    sed -i 's/^PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=skip/' "$WORKINGDIR"/Makefile
    cat "$WORKINGDIR"/Makefile | grep PKG_MIRROR_HASH

    local LUCIBRANCH="master"
    local LUCI_WD="$PARENT_DIR/wrt/feeds/luci/applications/luci-app-smartdns"
    mkdir -p "$LUCI_WD"
    rm -rf "$LUCI_WD"/*

    wget -q "https://github.com/pymumu/luci-app-smartdns/archive/${LUCIBRANCH}.zip" -O "$LUCI_WD/${LUCIBRANCH}.zip"
    unzip -q "$LUCI_WD/${LUCIBRANCH}.zip" -d "$LUCI_WD"
    mv "$LUCI_WD/luci-app-smartdns-${LUCIBRANCH}/"* "$LUCI_WD/"
    rmdir "$LUCI_WD/luci-app-smartdns-${LUCIBRANCH}"
    rm "$LUCI_WD/${LUCIBRANCH}.zip"

    echo "SmartDNS 安装完成"
}

install_smartdns

# remove v2ray-geodata package from feeds
rm -rf $PARENT_DIR/wrt/feeds/packages/net/v2ray-geodata
rm -rf $PARENT_DIR/wrt/feeds/packages/net/mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 $PARENT_DIR/wrt/package/mosdns
git clone https://github.com/sbwml/v2ray-geodata $PARENT_DIR/wrt/package/v2ray-geodata