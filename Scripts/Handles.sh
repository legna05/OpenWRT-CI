#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"
FEEDS_PATH="$GITHUB_WORKSPACE/wrt/feeds/"

#修复Rust编译失败
RUST_FILE=$(find $FEEDS_PATH/packages/ -maxdepth 3 -type f -wholename "*/rust/Makefile")
if [ -f "$RUST_FILE" ]; then
	echo " "
	sed -i 's/ci-llvm=true/ci-llvm=false/g' $RUST_FILE
	cd $PKG_PATH && echo "rust has been fixed!"
fi

#修改argon主题字体和颜色
ARGON_PATH=$FEEDS_PATH/theme_argon/luci-app-argon-config/root/etc/config/argon
if [ -f "$RUST_FILE" ]; then
  echo "start process argon config"
  sed -i "s/primary '.*'/primary '#e198b4'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" $ARGON_PATH
  echo "luci-theme-argon has been fixed!"
fi

#修改natmapt菜单位置
if [ -d "$PKG_PATH/luci-app-natmapt" ]; then
	echo " "
	if sed -i "s/network/services/g" \
		"$PKG_PATH/luci-app-natmapt/root/usr/share/luci/menu.d/luci-app-natmap.json"; then
		echo "natmapt has been fixed!"
	else
		echo "natmapt fix failed; continuing!"
	fi
fi

# mosdns修改geo文件路径
REPO_PATH="$GITHUB_WORKSPACE/Repo/"
cp -f $REPO_PATH/mosdns.uc $PKG_PATH/mosdns/luci-app-mosdns/root/usr/share/mosdns/
