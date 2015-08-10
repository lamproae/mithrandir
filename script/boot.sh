#!/bin/sh
if [ "$ARCH"x = "arm"x ]; then
	sudo qemu-system-arm -M versatilepb -net nic -net tap,ifname=tap0,script=no,downscript=no  -kernel build/arch/arm/boot/zImage -append vga=0x380 
elif [ "$ARCH"x = "x86_64"x ]; then
	sudo qemu-system-x86_64 -m 2000 -net nic -net tap,ifname=tap0,script=no,downscript=no  -kernel build/arch/x86/boot/bzImage -append vga=0x380 -vga vmware
else
	echo "Unsupported target platform"
	exit -1
fi
 

