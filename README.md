
# 从头编译 OpenWrt（TXCZ RK3128 V3-1）

## 一、安装编译环境

更新软件包列表：

```bash
sudo apt update
```

安装编译所需依赖：

```bash
sudo apt install -y \
  build-essential clang flex bison g++ gawk gcc-multilib \
  g++-multilib gettext git libncurses-dev libssl-dev \
  python3 python3-setuptools python3-dev rsync swig unzip \
  zlib1g-dev file wget curl time \
  libelf-dev libdw-dev libcap-dev \
  cpio ecj fastjar java-propose-classpath \
  libgmp3-dev libmpc-dev libmpfr-dev \
  libxml-parser-perl libyaml-dev xsltproc \
  qemu-utils mkisofs
```

## 二、下载 OpenWrt 源码

克隆 `rk3128-dev` 分支：

```bash
cd ~

git clone \
  --branch rk3128-dev \
  --single-branch \
  git@github.com:mingrizaizao/openwrt.git \
  openwrt
```

进入源码目录：

```bash
cd ~/openwrt
```

## 三、安装软件源依赖

更新所有 feeds：

```bash
cd ~/openwrt

./scripts/feeds update -a
```

安装所有 feeds 软件包：

```bash
./scripts/feeds install -a
```

## 四、配置编译选项

进入 OpenWrt 源码目录：

```bash
cd ~/openwrt
```

复制 TXCZ RK3128 V3-1 配置文件：

```bash
cp txcz-rk3128-v3-1.config .config
```

生成默认配置：

```bash
make defconfig
```

## 五、下载源码并编译

下载编译所需源码：

```bash
make download -j8
```

开始编译：

```bash
make -j$(nproc) V=s
```

其中：

- `-j$(nproc)`：使用当前系统所有可用 CPU 线程进行并行编译。
- `V=s`：显示详细编译信息，便于排查编译错误。

## 六、查看编译生成的镜像

查看目标目录下生成的文件：

```bash
find bin/targets/rockchip/armv7/ \
  -maxdepth 1 \
  -type f \
  -printf '%f\n'
```

## 七、烧录内存卡

### 1. 确认内存卡设备

查看磁盘设备信息：

```bash
lsblk -o NAME,SIZE,MODEL,TRAN,FSTYPE,MOUNTPOINTS
```

确认内存卡对应的设备名称。

**注意：以下命令以 `/dev/sda` 为例，实际操作时必须确认它是内存卡，避免误写电脑硬盘。**

### 2. 确认镜像文件

进入 OpenWrt 源码目录：

```bash
cd ~/openwrt
```

检查生成的 sysupgrade 镜像：

```bash
ls -l bin/targets/rockchip/armv7/openwrt-rockchip-armv7-txcz_rk3128-v3-1-squashfs-sysupgrade.img.gz
```

设置镜像文件路径：

```bash
FILE=bin/targets/rockchip/armv7/openwrt-rockchip-armv7-txcz_rk3128-v3-1-squashfs-sysupgrade.img.gz
```

### 3. 卸载内存卡分区

卸载内存卡上已挂载的分区：

```bash
sudo umount /dev/sda1 2>/dev/null || true
sudo umount /dev/sda2 2>/dev/null || true
```

### 4. 写入内存卡

解压 gzip 镜像并写入内存卡：

```bash
gzip -dc "$FILE" | sudo dd of=/dev/sda bs=4M status=progress conv=fsync
```

等待写入完成后执行：

```bash
sync
```

至此，OpenWrt 镜像已写入内存卡。















![OpenWrt logo](include/logo.png)

OpenWrt Project is a Linux operating system targeting embedded devices. Instead
of trying to create a single, static firmware, OpenWrt provides a fully
writable filesystem with package management. This frees you from the
application selection and configuration provided by the vendor and allows you
to customize the device through the use of packages to suit any application.
For developers, OpenWrt is the framework to build an application without having
to build a complete firmware around it; for users this means the ability for
full customization, to use the device in ways never envisioned.

Sunshine!

## Download

Built firmware images are available for many architectures and come with a
package selection to be used as WiFi home router. To quickly find a factory
image usable to migrate from a vendor stock firmware to OpenWrt, try the
*Firmware Selector*.

* [OpenWrt Firmware Selector](https://firmware-selector.openwrt.org/)

If your device is supported, please follow the **Info** link to see install
instructions or consult the support resources listed below.

## 

An advanced user may require additional or specific package. (Toolchain, SDK, ...) For everything else than simple firmware download, try the wiki download page:

* [OpenWrt Wiki Download](https://openwrt.org/downloads)

## Development

To build your own firmware you need a GNU/Linux, BSD or macOS system (case
sensitive filesystem required). Cygwin is unsupported because of the lack of a
case sensitive file system.

### Requirements

You need the following tools to compile OpenWrt, the package names vary between
distributions. A complete list with distribution specific packages is found in
the [Build System Setup](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem)
documentation.

```
binutils bzip2 diff find flex gawk gcc-6+ getopt grep install libc-dev libz-dev
make4.1+ perl python3.7+ rsync subversion unzip which
```

### Quickstart

1. Run `./scripts/feeds update -a` to obtain all the latest package definitions
   defined in feeds.conf / feeds.conf.default

2. Run `./scripts/feeds install -a` to install symlinks for all obtained
   packages into package/feeds/

3. Run `make menuconfig` to select your preferred configuration for the
   toolchain, target system & firmware packages.

4. Run `make` to build your firmware. This will download all sources, build the
   cross-compile toolchain and then cross-compile the GNU/Linux kernel & all chosen
   applications for your target system.

### Related Repositories

The main repository uses multiple sub-repositories to manage packages of
different categories. All packages are installed via the OpenWrt package
manager called `opkg`. If you're looking to develop the web interface or port
packages to OpenWrt, please find the fitting repository below.

* [LuCI Web Interface](https://github.com/openwrt/luci): Modern and modular
  interface to control the device via a web browser.

* [OpenWrt Packages](https://github.com/openwrt/packages): Community repository
  of ported packages.

* [OpenWrt Routing](https://github.com/openwrt/routing): Packages specifically
  focused on (mesh) routing.

* [OpenWrt Video](https://github.com/openwrt/video): Packages specifically
  focused on display servers and clients (Xorg and Wayland).

## Support Information

For a list of supported devices see the [OpenWrt Hardware Database](https://openwrt.org/supported_devices)

### Documentation

* [Quick Start Guide](https://openwrt.org/docs/guide-quick-start/start)
* [User Guide](https://openwrt.org/docs/guide-user/start)
* [Developer Documentation](https://openwrt.org/docs/guide-developer/start)
* [Technical Reference](https://openwrt.org/docs/techref/start)

### Support Community

* [Forum](https://forum.openwrt.org): For usage, projects, discussions and hardware advise.
* [Support Chat](https://webchat.oftc.net/#openwrt): Channel `#openwrt` on **oftc.net**.

### Developer Community

* [Bug Reports](https://bugs.openwrt.org): Report bugs in OpenWrt
* [Dev Mailing List](https://lists.openwrt.org/mailman/listinfo/openwrt-devel): Send patches
* [Dev Chat](https://webchat.oftc.net/#openwrt-devel): Channel `#openwrt-devel` on **oftc.net**.

## License

OpenWrt is licensed under GPL-2.0
