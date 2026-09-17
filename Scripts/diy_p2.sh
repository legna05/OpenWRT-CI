#!/bin/bash

feeds_path="/home/runner/work/OpenWRT-CI/OpenWRT-CI/wrt/scripts/feeds"

#优先安装 passwall 源
$feeds_path install -a -f -p passwall_packages
$feeds_path install -a -f -p passwall_luci
$feeds_path install -a -f -p openclash
$feeds_path install -a -f -p nikki
$feeds_path install -a -f -p gecoosac
$feeds_path install -a -f -p ddns_go
$feeds_path install -a -f -p socat
$feeds_path install -a -f -p theme_argon

PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
# remove v2ray-geodata package from feeds
rm -rf $PARENT_DIR/wrt/feeds/packages/net/v2ray-geodata
rm -rf $PARENT_DIR/wrt/feeds/packages/net/mosdns
git clone https://github.com/sbwml/luci-app-mosdns -b v5 $PARENT_DIR/wrt/package/mosdns
git clone https://github.com/sbwml/v2ray-geodata $PARENT_DIR/wrt/package/v2ray-geodata