#!/bin/sh

# エラーが出たら中断
set -e

# dkmsとpx4_drvのインストールチェック
if command -v dkms > /dev/null && dkms status | grep -q px4_drv; then
  echo 'DKMS found and px4_drv already installed.'
  echo 'If you have any problems with px4_drv, please run ./uninstall.sh first.'
  exit 1
fi

# ドライバインストールに必要なDKMSとカーネルヘッダをインストール
echo '=== Install DKMS and Kernel Headers ==='
apt install -y dkms linux-headers-$(uname -r)

# ドライバのコピー先ディレクトリを作成
mkdir -p /lib/firmware /usr/src/px4_drv-0.2.1

# dockerを用いてドライバをビルド
echo && echo '=== Build Driver using Docker ==='
docker run --rm \
  -v /lib/firmware:/lib/firmware:rw \
  -v /usr/src/px4_drv-0.2.1:/usr/src/px4_drv-0.2.1:rw \
  ureo/tsd-px4_drv
docker rmi -f ureo/tsd-px4_drv

# DKMSを使ってインストール
echo && echo '=== Install Driver using DKMS ==='
dkms add px4_drv/0.2.1
dkms install px4_drv/0.2.1 # --force

# Raspberry Pi OSのために設定を変更
# coherent_pool: 4TSを行うために4MBのメモリプールがDMA操作に使用する
# dwc_otg.host_rx_fifo_size: USBホストコントローラの受信FIFOサイズを設定
# https://kaikoma-soft.github.io/src/raspi_OS_install.html
config='coherent_pool=4M dwc_otg.host_rx_fifo_size=2048'
config_path='/boot/cmdline.txt'

if ! grep -q "$config" $config_path; then
  echo && echo '=== Add Some Config for OS ==='
  echo "$config" >> $config_path
fi

echo && echo 'Install Completed! The driver will be available after reboot.'
