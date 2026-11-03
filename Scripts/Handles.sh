#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2026 VIKINGYFY

PKG_PATH="$GITHUB_WORKSPACE/wrt/package/"
FEEDS_PATH="$GITHUB_WORKSPACE/wrt/feeds/"

#修改argon主题字体和颜色
ARGON_PATH=$FEEDS_PATH/theme_argon/luci-app-argon-config/root/etc/config/argon
if [ -f "$ARGON_PATH" ]; then
  echo "start process argon config"
  sed -i "s/primary '.*'/primary '#e198b4'/; s/'0.2'/'0.5'/; s/'none'/'bing'/; s/'600'/'normal'/" $ARGON_PATH
  echo "luci-theme-argon has been fixed!"
fi

#修改vantage进度条标签字体（anothaDev/luci-theme-vantage#52）
if [ -d "$PACKAGE_PATH/luci-theme-vantage" ]; then
	echo "fix luci-theme-vantage"
    sed -i -e '/^\/\* progress bars: thin track/,$ { /^\.cbi-progressbar::before {/,/^}/ { s/^[[:space:]]*font: 500 var(--fs-micro)\/1\.2 var(--mono);/\tfont: inherit; line-height: normal;/; } }' \
    "$PACKAGE_PATH/luci-theme-vantage/luci-theme-vantage/htdocs/luci-static/vantage/vantage.css"
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