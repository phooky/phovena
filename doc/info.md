RESOURCES
---------
cross compiling in rust https://github.com/japaric/rust-cross

install toolset
---------------

sudo apt-get install gcc-arm-none-eabi binutils-arm-none-eabi device-tree-compiler
 

build u-boot
------------

make ARCH=arm CROSS_COMPILE=arm-none-eabi- vexpress_ca9x4_config
make ARCH=arm CROSS_COMPILE=arm-none-eabi-

run u-boot
----------

qemu-system-arm -M vexpress-a9 -m 1G -nographic -kernel u-boot

install tftpd
-------------
sudo apt-get install tftpd-hpa
edit /etc/default/tftpd to set address as "127.0.0.1:69" to explicitly support ipv4
sudo chown root:sudo /var/lib/tftpboot/
sudo chmod g+w /var/lib/tftpboot/

make image
----------
mkimage -f src/arch/cortex-a9/phovena.fits img-cortex-a9

tftp boot
---------

> dhcp
> set serverip 127.0.0.1
> set bootfile img-cortex-a9
> bdinfo (to check memory locations)
> tftpboot 0x60000000
> bootm? wtf?

remote debgging
---------------
arm-non-eabi-gdb
> target remote :1234


TODO
----

setup qemu networking
boot off of tftp