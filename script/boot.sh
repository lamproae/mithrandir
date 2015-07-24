#!/bin/sh
sudo qemu-system-x86_64 -m 2000 -net nic -net tap,ifname=tap0,script=no,downscript=no  -kernel build/arch/x86/boot/bzImage -append vga=0x380 -vga vmware
 

