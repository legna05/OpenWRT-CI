#!/bin/bash

feeds_path="/home/runner/work/OpenWRT-CI/OpenWRT-CI/wrt/scripts/feeds"

#优先安装 passwall 源
$feeds_path install -a -f -p passwall_packages
$feeds_path install -a -f -p passwall_luci
$feeds_path install -a -f -p openclash
#优先安装 ddns-go 源
#./scripts/feeds update ddns-go
$feeds_path install -a -f -p ddns_go
