#!/bin/sh

# DKMSが存在すれば、ドライバをアンインストール
if command -v dkms > /dev/null && dkms status | grep -q px4_drv; then
  echo '=== Uninstall px4_drv using DKMS ==='
  dkms remove px4_drv/0.2.1 --all
  echo
fi

echo '=== Delete built files ==='
rm -rf /lib/firmware/it930x-firmware.bin
rm -rf /usr/src/px4_drv-0.2.1
echo

# Raspberry Pi OSのための設定を変更を削除
config='coherent_pool=4M dwc_otg.host_rx_fifo_size=2048'
config_path='/boot/cmdline.txt'

if grep -q "$config" $config_path; then
  echo '=== Found Some Config for OS ==='
  if grep -q "^$config$" $config_path; then
    sed -i "/$config/d" /boot/cmdline.txt
    echo 'OS settings has been changed, please reboot.'
  else
    echo "Since it was not possible to delete the configuration automatically, please edit ${config_path} manually, delete \"${config}\" and reboot."
  fi
fi
