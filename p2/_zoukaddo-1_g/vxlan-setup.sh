#!/bin/sh

ip addr flush dev eth1
ip addr add 10.0.0.1/24 dev eth1
ip link set eth1 up

ip link add vxlan10 type vxlan id 10 dev eth1 remote 10.0.0.2 dstport 4789
ip link set vxlan10 up

brctl addbr br0
brctl addif br0 vxlan10
brctl addif br0 eth0
ip link set eth0 up
ip link set br0 up
