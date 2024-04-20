# tsd: px4-driver

PLEXなどのチューナーの非公式ドライバをコンテナ内でビルドし、インストールするもの。

ドライバについては大本のリポジトリを参照してください。

[![nns779/px4_drv - GitHub](https://gh-card.dev/repos/nns779/px4_drv.svg)](https://github.com/nns779/px4_drv)

## インストール方法

内部でaptコマンドを使用します。

```sh
sudo ./install.sh
```

## 各種確認

### カーネルドライバ

`px4_drv, x.x.x, [kernel_version], [architecture]: installed` と表示されることを確認

```sh
dkms status
```

### モジュールの確認 (要再起動)

```sh
lsmod | grep ^px4_drv
```

### 正しくデバイスが読み込まれているか確認 (要再起動)

```sh
dmesg | grep px4_usb
```

### デバイスが存在するか確認 (要再起動)

```sh
ls /dev/px*
```

### インストール済みのカーネルヘッダの確認

```sh
ls /usr/src/ | grep linux-headers
```
