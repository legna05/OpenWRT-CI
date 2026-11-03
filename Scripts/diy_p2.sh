#!/bin/bash

feeds_path="/home/runner/work/OpenWRT-CI/OpenWRT-CI/wrt/scripts/feeds"

#优先安装 passwall 源
$feeds_path install -a -f -p ddns_go
$feeds_path install -a -f -p socat