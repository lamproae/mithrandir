#!/bin/sh

sudo ifconfig eth0 down

# Add bridge 0
sudo brctl addbr br0
sudo brctl addif br0 eth0
sudo brctl stp br0 off
sudo brctl setfd br0 1
sudo brctl sethello br0 1

sudo ifconfig br0 0.0.0.0 promisc up
sudo ifconfig eth0 0.0.0.0 promisc up

sudo ifconfig br0 192.168.1.201 netmask 255.255.255.0
sudo route add -net 0.0.0.0 netmask 0.0.0.0 gw 192.168.1.254

sudo brctl show br0
sudo brctl showstp br0

sudo tunctl -t tap0 -u root
sudo brctl addif br0 tap0
sudo ifconfig tap0 0.0.0.0 promisc up
sudo brctl showstp br0


