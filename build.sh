#!/bin/sh

# エラーが出たら中断
set -e

wget -O - http://plex-net.co.jp/plex/pxw3u4/pxw3u4_BDA_ver1x64.zip | unzip -oj - pxw3u4_BDA_ver1x64/PXW3U4.sys
./fwtool PXW3U4.sys it930x-firmware.bin

cp it930x-firmware.bin /lib/firmware/
cp -a /px4_drv-develop/* /usr/src/px4_drv-0.2.1
