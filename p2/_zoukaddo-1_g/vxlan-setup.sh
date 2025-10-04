#!/bin/sh

# Configure underlay network interface
ip addr flush dev eth1
ip addr add 10.0.0.1/24 dev eth1
ip link set eth1 up

# Static VXLAN configuration (point-to-point)
ip link add vxlan10 type vxlan id 10 dev eth1 remote 10.0.0.2 dstport 4789
ip link set vxlan10 up

# Dynamic multicast VXLAN configuration
# Create VXLAN with multicast group 239.1.1.1
ip link add vxlan10-mc type vxlan id 10 dev eth1 group 239.1.1.1 dstport 4789
ip link set vxlan10-mc up

# Create bridge br0 and add interfaces
brctl addbr br0
brctl addif br0 vxlan10
brctl addif br0 eth0
ip link set eth0 up
ip link set br0 up

# Display configuration for verification
echo "VXLAN Configuration:"
ip link show type vxlan
echo "Bridge Configuration:"
brctl show
echo "MAC Address Table:"
brctl showmacs br0
