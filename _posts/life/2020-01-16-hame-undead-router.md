---
layout: post
title:  "Hame from the Dead"
tags: ["Recovery", "UART", "Bootloader"]
categories: life
---

Million years ago I've bought on Aliexpress this Hame HX-G668E. router / modem / powerbank thing. I don't even remember why actually. Some time ago I found it and tried to update firmware with new one from 4PDA, and of course it failed.

Seeing all this videos about UART hacks I woundered if I can recover my device as well by soldering wires. 

It worked.

# Dissasembly and preparation

Dissasembly is pretty straightforward - just un-snap plastic side and unscrew 3 screws. Then unsnap bottom part and disconnect battery.

Luckily `TX` and `RX` contacts are alrady marked.

Then, using multimeter I found `+` and `GND` and soldered wires for UART connection.

Here are some images of my modem:

![Modem iteslf](/assets/2020-01-16/box.JPG)  
![PCB Board Back](/assets/2020-01-16/back.JPG)  

![PCB Without Wires](/assets/2020-01-16/front_clean.JPG)  
![PCB With UAR Wires](/assets/2020-01-16/front_wires.JPG)  

# Console part

Then I connected my serial adapter went to console. 

(Mobaxterm Serial connection with baud rate 57600).

Here is what I saw:


```bash
{% raw %}
U-Boot 1.1.3 Rev 0.3 by WErt(WErt) 4PDA (May 19 2016 - 14:46:46)

Board: Ralink APSoC DRAM: 32 MB
Ralink SPI flash driver, SPI clock: 15MHz
spi device id: 7f 9d 46 7f 9d (9d467f9d)
find flash: Pm25LQ032
.*** Warning - bad CRC, using default environment


===========================================
Ralink U-Boot Version: 5.0.0.5

ASIC 5350_MP (Port5<->None)
DRAM_CONF_FROM: Boot-Strapping
DRAM_TYPE: SDRAM
DRAM_SIZE: 256 Mbits
DRAM_WIDTH: 16 bits
DRAM_TOTAL_WIDTH: 16 bits
TOTAL_MEMORY_SIZE: 32 MBytes
Flash component: SPI Flash
Date:May 19 2016  Time:14:46:46
============================================
icache: sets:256, ways:4, linesz:32, total:32768
dcache: sets:128, ways:4, linesz:32, total:16384

 #### The CPU freq = 360 MHZ ####
 estimate memory size = 32 Mbytes

Please choose the operation:
   0: Load system code then write to Flash via Serial.
   1: Load system code to SDRAM via TFTP.
   2: Load system code then write to Flash via TFTP.
   3: Boot system code via Flash (default).
   4: Enter boot command line interface.
   5: Load system code then write to Flash via USB Storage.
   6: Load U-Boot code then write to Flash via USB Storage.
   7: Load U-Boot code then write to Flash via Serial.
   8: Load U-Boot code to SDRAM via TFTP.
   9: Load U-Boot code then write to Flash via TFTP.
 0 .
 {% endraw %}
```

I was pretty lucky because for some reason before bricking device I already had bootloader with dozen of options above. Otherwise I had to start TFTP server and host firmware files for modem to download.

Let's go through the numbers below and how we can use them:

# 4 CLI

That's what you'll get when running CLI. Not helpfull from clasicall __sh__ standpoint, but still `better than poke in the eye (C)`. 

```bash
{% raw %}
4: System Enter Boot Command Line Interface.

U-Boot 1.1.3 Rev 0.3 by WErt(WErt) 4PDA (May 19 2016 - 14:46:46)
RT5350 # help
?       - alias for 'help'
bootm   - boot application image from memory
cp      - memory copy
crc32   - checksum calculation
erase   - erase SPI FLASH memory
fatinfo - print information about filesystem
fatload - load binary file from a dos filesystem
fatls   - list files in a directory (default /)
go      - start application at address 'addr'
help    - print online help
loadb   - load binary file over serial line (kermit mode)
md      - memory display
mdio    - Ralink PHY register R/W command !!
mm      - memory modify (auto-incrementing)
nm      - memory modify (constant address)
printenv- print environment variables
reset   - Perform RESET of the CPU
rf      - read/write rf register
saveenv - save environment variables to persistent storage
setenv  - set environment variables
tftpboot- boot image via network using TFTP protocol
tftpd   - load the data by tftp protocol
usb     - USB sub-system
usbboot - boot from USB device
version - print monitor version
{% endraw %}
```

# 5 System update

For this one to work you shoukd have USB drive with Fat32 and file `firmware.bin` in the root folder.
Here is what happens if you put wrong file (in my case i used `bootloader` instead of firware):

```bash
{% raw %}
5: System Load Linux then write to Flash via USB Storage.
 Warning!! Erase Linux in Flash then burn new one. Are you sure? (Y/N)
(Re)start USB...
USB0:   * ehci_hcd_init *
Ralink USB EHCI host init, hccr b01c0000, hcor b01c0010, hc_length 16
Register 1111 NbrPorts 1
USB EHCI 1.00
scanning bus 0 for devices... 2 USB Device(s) found
       scanning bus for storage devices... 1 Storage Device(s) found
reading firmware.bin
.............
............

138396 bytes read
Linux image size 138396 too small!
```

Here what's going on when normal firmware is used:

```bash
5: System Load Linux then write to Flash via USB Storage.
 Warning!! Erase Linux in Flash then burn new one. Are you sure? (Y/N)
(Re)start USB...
USB0:   * ehci_hcd_init *
Ralink USB EHCI host init, hccr b01c0000, hcor b01c0010, hc_length 16
Register 1111 NbrPorts 1
USB EHCI 1.00
scanning bus 0 for devices... 2 USB Device(s) found
       scanning bus for storage devices... 1 Storage Device(s) found
reading firmware.bin
.............
................................................................
................................................................
.....................................................

3670020 bytes read
## Checking image at 81000000 ...
   Image Name:   MIPS OpenWrt Linux-3.18.36
   Image Type:   MIPS Linux Kernel Image (lzma compressed)
   Data Size:    1090935 Bytes =  1 MB
   Load Address: 80000000
   Entry Point:  80000000
   Verifying Checksum ... OK

 Copy 3670020 bytes to Flash...
........................................................
........................................................
..........................................................
.
.Done!
3670020 bytes flashed
{% endraw %}
```


# 6 Bootloader Update

```bash
{% raw %}
6: System Load U-Boot then write to Flash via USB Storage.
 Warning!! Erase U-Boot in Flash then burn new one. Are you sure? (Y/N)
(Re)start USB...
USB0:   * ehci_hcd_init *
Ralink USB EHCI host init, hccr b01c0000, hcor b01c0010, hc_length 16
Register 1111 NbrPorts 1
USB EHCI 1.00
scanning bus 0 for devices... 2 USB Device(s) found
       scanning bus for storage devices... 1 Storage Device(s) found
reading uboot.img
.............
............

138396 bytes read

 Copy 138396 bytes to Flash...
..
..
....
.
.Done!
138396 bytes flashed

SYSTEM RESET!!!
{% endraw %}
```



# 3 Normal Boot

After flash process was sucesfull you'll get to a lot of awesome text about your system. 

```bash
{% raw %}
3: System Boot system code via Flash.
## Checking image at bc050000 ...
.   Image Name:   MIPS OpenWrt Linux-3.18.36
   Image Type:   MIPS Linux Kernel Image (lzma compressed)
   Data Size:    1090935 Bytes =  1 MB
   Load Address: 80000000
   Entry Point:  80000000
.................   Verifying Checksum ... OK
   Uncompressing Kernel Image ... OK
No initrd
## Transferring control to Linux (at address 80000000) ...
## Giving linux memsize in MB, 32

Starting kernel ...

[    0.000000] Linux version 3.18.36 (root@oleg-A8Le) (gcc version 4.8.3 
(OpenWrt/Linaro GCC 4.8-2014.04 r49403) ) #3 Fri Oct 14 10:52:34 MSK 2016
[    0.000000] SoC Type: Ralink RT5350 id:1 rev:3
[    0.000000] bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 0001964c (MIPS 24KEc)
[    0.000000] MIPS: machine is A5-V11
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 02000000 @ 00000000 (usable)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00000000-0x01ffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00000000-0x01ffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x01ffffff]
[    0.000000] Primary instruction cache 32kB, VIPT, 4-way, linesize 32 bytes.
[    0.000000] Primary data cache 16kB, 4-way, VIPT, no aliases, linesize 32 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
[    0.000000] Kernel command line: console=ttyS0,57600 rootfstype=squashfs,jffs2
[    0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
[    0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Writing ErrCtl register=0003dfc0
[    0.000000] Readback ErrCtl register=0003dfc0
[    0.000000] Memory: 29016K/32768K available (2416K kernel code, 119K rwdata, 476K rodata, 180K init, 181K bss, 3752K reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:256
[    0.000000] CPU Clock: 360MHz
[    0.000000] systick: running - mult: 214748, shift: 32
[    0.010000] Calibrating delay loop... 239.61 BogoMIPS (lpj=1198080)
[    0.080000] pid_max: default: 32768 minimum: 301
[    0.090000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.100000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.110000] pinctrl core: initialized pinctrl subsystem
[    0.120000] NET: Registered protocol family 16
[    0.170000] rt2880_gpio 10000600.gpio: registering 22 gpios
[    0.180000] rt2880_gpio 10000600.gpio: registering 22 irq handlers
[    0.190000] rt2880_gpio 10000660.gpio: registering 6 gpios
[    0.200000] rt2880_gpio 10000660.gpio: registering 6 irq handlers
[    0.210000] Switched to clocksource systick
[    0.220000] NET: Registered protocol family 2
[    0.230000] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[    0.240000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[    0.250000] TCP: Hash tables configured (established 1024 bind 1024)
[    0.270000] TCP: reno registered
[    0.270000] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.280000] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.300000] NET: Registered protocol family 1
[    0.310000] rt-timer 10000100.timer: maximum frequency is 7324Hz
[    0.320000] futex hash table entries: 256 (order: -1, 3072 bytes)
[    0.350000] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.360000] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME) (CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[    0.380000] msgmni has been set to 56
[    0.400000] io scheduler noop registered
[    0.400000] io scheduler deadline registered (default)
[    0.410000] ralink-usb-phy usbphy: invalid resource
[    0.430000] gpio-export gpio_export: 2 gpio(s) exported
[    0.440000] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.450000] console [ttyS0] disabled
[    0.460000] 10000c00.uartlite: ttyS0 at MMIO 0x10000c00 (irq = 20, base_baud = 2500000) is a 16550A
[    0.480000] console [ttyS0] enabled
[    0.480000] console [ttyS0] enabled
[    0.490000] bootconsole [early0] disabled
[    0.490000] bootconsole [early0] disabled
[    0.550000] m25p80 spi32766.0: pm25lq032 (4096 Kbytes)
[    0.560000] 4 ofpart partitions found on MTD device spi32766.0
[    0.570000] Creating 4 MTD partitions on "spi32766.0":
[    0.580000] 0x000000000000-0x000000030000 : "u-boot"
[    0.590000] 0x000000030000-0x000000040000 : "u-boot-env"
[    0.600000] 0x000000040000-0x000000050000 : "factory"
[    0.620000] 0x000000050000-0x000000400000 : "firmware"
[    0.670000] 2 uimage-fw partitions found on MTD device firmware
[    0.680000] 0x000000050000-0x00000015a5b7 : "kernel"
[    0.690000] 0x00000015a5b7-0x000000400000 : "rootfs"
[    0.700000] mtd: device 5 (rootfs) set to be root filesystem
[    0.710000] 1 squashfs-split partitions found on MTD device rootfs
[    0.730000] 0x0000003b0000-0x000000400000 : "rootfs_data"
[    0.740000] ralink_soc_eth 10100000.ethernet eth0: ralink at 0xb0100000, irq 5
[    0.760000] rt2880_wdt 10000120.watchdog: Initialized
[    0.770000] TCP: cubic registered
[    0.780000] NET: Registered protocol family 17
[    0.790000] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[    0.810000] 8021q: 802.1Q VLAN Support v1.8
[    0.850000] VFS: Mounted root (squashfs filesystem) readonly on device 31:5.
[    0.870000] Freeing unused kernel memory: 180K (802f3000 - 80320000)
[    4.210000] init: Console is alive
[    4.220000] init: - watchdog -
[    7.450000] usbcore: registered new interface driver usbfs
[    7.460000] usbcore: registered new interface driver hub
[    7.470000] usbcore: registered new device driver usb
[    7.500000] SCSI subsystem initialized
[    7.520000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.540000] ehci-platform: EHCI generic platform driver
[    7.560000] phy phy-usbphy.0: remote usb device wakeup disabled
[    7.570000] phy phy-usbphy.0: UTMI 16bit 30MHz
[    7.580000] ehci-platform 101c0000.ehci: EHCI Host Controller
[    7.590000] ehci-platform 101c0000.ehci: new USB bus registered, assigned bus number 1
[    7.610000] ehci-platform 101c0000.ehci: irq 26, io mem 0x101c0000
[    7.640000] ehci-platform 101c0000.ehci: USB 2.0 started, EHCI 1.00
[    7.650000] hub 1-0:1.0: USB hub found
[    7.660000] hub 1-0:1.0: 1 port detected
[    7.670000] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.680000] ohci-platform: OHCI generic platform driver
[    7.690000] ohci-platform 101c1000.ohci: Generic Platform OHCI controller
[    7.710000] ohci-platform 101c1000.ohci: new USB bus registered, assigned bus number 2
[    7.720000] ohci-platform 101c1000.ohci: irq 26, io mem 0x101c1000
[    7.800000] hub 2-0:1.0: USB hub found
[    7.810000] hub 2-0:1.0: 1 port detected
[    7.830000] usbcore: registered new interface driver usb-storage
[    7.990000] usb 1-1: new high-speed USB device number 2 using ehci-platform
[    8.150000] usb-storage 1-1:1.0: USB Mass Storage device detected
[    8.160000] scsi host0: usb-storage 1-1:1.0
[    8.290000] init: - preinit -
[    9.560000] scsi 0:0:0:0: Direct-Access     Generic  USB Flash Disk   0.00 PQ: 0 ANSI: 6
[    9.580000] random: procd urandom read with 15 bits of entropy available
[    9.600000] sd 0:0:0:0: [sda] 15974400 512-byte logical blocks: (8.17 GB/7.61 GiB)
[    9.620000] sd 0:0:0:0: [sda] Write Protect is off
[    9.630000] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesnt support DPO or FUA
[    9.780000]  sda: sda1
[    9.790000] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    9.810000] rt305x-esw 10110000.esw: link changed 0x00
Press the [f] key and hit [enter] to enter failsafe mode
Press the [1], [2], [3] or [4] key and hit [enter] to select the debug level
[   13.430000] mount_root: loading kmods from internal overlay
[   14.490000] block: attempting to load /etc/config/fstab
[   14.500000] block: unable to load configuration (fstab: Entry not found)
[   14.520000] block: no usable configuration
[   14.530000] mount_root: jffs2 not ready yet, using temporary tmpfs overlay
[   14.580000] procd: - early -
[   14.590000] procd: - watchdog -
[   15.840000] procd: - ubus -
[   16.860000] procd: - init -
Please press Enter to activate this console.
[   19.630000] gre: GRE over IPv4 demultiplexor driver
[   19.640000] ip_gre: GRE over IPv4 tunneling driver
[   19.690000] usbcore: registered new interface driver cdc_wdm
[   19.710000] Loading modules backported from Linux version v4.4-rc5-1913-gc8fdf68
[   19.720000] Backport generated by backports.git backports-20151218-0-g2f58d9d


BusyBox v1.23.2 (2016-10-14 08:18:31 MSK) built-in shell (ash)

[   19.770000] nf_conntrack version 0.5.0 (456 buckets, 1824 max)
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 
 CHAOS CALMER (Chaos Calmer, r49403)
 
  * 1 1/2 oz Gin            Shake with a glassful
  * 1/4 oz Triple Sec       of broken ice and pour
  * 3/4 oz Lime Juice       unstrained into a goblet.
  * 1 1/2 oz Orange Juice
  * 1 tsp. Grenadine Syrup
 ----[   19.920000] usbcore: registered new interface driver usblp

root@(none):/# [   19.980000] usbcore: registered new interface driver usbserial
[   19.990000] usbcore: registered new interface driver usbserial_generic
[   20.010000] usbserial: USB Serial support registered for generic
[   20.120000] xt_time: kernel timezone is -0000
[   20.130000] usbcore: registered new interface driver asix
[   20.150000] usbcore: registered new interface driver cdc_eem
[   20.160000] usbcore: registered new interface driver cdc_ether
[   20.180000] usbcore: registered new interface driver cdc_ncm
[   20.200000] usbcore: registered new interface driver cdc_subset
[   20.270000] usbcore: registered new interface driver huawei_cdc_ncm
[   20.290000] ip_tables: (C) 2000-2006 Netfilter Core Team
[   20.410000] usbcore: registered new interface driver pl2303
[   20.420000] usbserial: USB Serial support registered for pl2303
[   20.440000] PPP generic driver version 2.4.2
[   20.450000] PPP MPPE Compression module registered
[   20.470000] NET: Registered protocol family 24
[   20.480000] PPTP driver version 0.8.5
[   20.490000] usbcore: registered new interface driver qmi_wwan
[   20.510000] usbcore: registered new interface driver rndis_host
[   20.550000] usbcore: registered new interface driver sierra
[   20.560000] usbserial: USB Serial support registered for Sierra USB modem
[   20.580000] usbcore: registered new interface driver sierra_net
[   20.600000] usbcore: registered new interface driver cdc_mbim
[   20.620000] usbcore: registered new interface driver ipw
[   20.630000] usbserial: USB Serial support registered for IPWireless converter
[   20.650000] usbcore: registered new interface driver option
[   20.660000] usbserial: USB Serial support registered for GSM modem (1-port)
[   20.690000] usbcore: registered new interface driver qcserial
[   20.700000] usbserial: USB Serial support registered for Qualcomm USB modem
[   20.750000] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5350, rev 0500 detected
[   20.760000] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 5350 detected
[   33.470000] rt305x-esw 10110000.esw: link changed 0x10
[   34.840000] jffs2_scan_eraseblock(): End of filesystem marker found at 0x0
[   34.850000] jffs2_build_filesystem(): unlocking the mtd device... done.
[   34.860000] jffs2_build_filesystem(): erasing all blocks after the end marker... done.
[   37.710000] jffs2: notice: (1166) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
[   38.080000] device eth0.1 entered promiscuous mode
[   38.090000] device eth0 entered promiscuous mode
[   38.130000] br-lan: port 1(eth0.1) entered forwarding state
[   38.140000] br-lan: port 1(eth0.1) entered forwarding state
[   40.140000] br-lan: port 1(eth0.1) entered forwarding state
[   43.730000] device wlan0 entered promiscuous mode
[   43.820000] br-lan: port 2(wlan0) entered forwarding state
[   43.830000] br-lan: port 2(wlan0) entered forwarding state
[   45.830000] br-lan: port 2(wlan0) entered forwarding state

{% endraw %}
```

# Finale
Now I can connect to Open Wifi Enpoint and see awesome web-ui (via 192.168.10.1) with OpenWrt.

[4pda-general]: http://4pda.ru/forum/index.php?showtopic=709298
[4pda-recovery]: http://4pda.ru/forum/index.php?showtopic=730274
[uboot]: http://4pda.ru/forum/index.php?showtopic=377187&st=3800#entry49686809
[firmware]:  http://4pda.ru/pages/go/?u=https%3A%2F%2Fyadi.sk%2Fd%2FIvDPhjFC3QZhfV&e=45137099