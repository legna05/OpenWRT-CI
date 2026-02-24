#!/bin/bash

feeds_path="/home/runner/work/OpenWRT-CI/OpenWRT-CI/wrt/scripts/feeds"

$feeds_path install -a -f -p passwall_packages
$feeds_path install -a -f -p passwall_luci
$feeds_path install -a -f -p openclash
$feeds_path install -a -f -p netspeedtest
$feeds_path install -a -f -p turboacc
$feeds_path install -a -f -p ddns_go
