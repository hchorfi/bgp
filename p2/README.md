# P2 - VXLAN Network Configuration

## Overview
This project implements a VXLAN (Virtual Extensible LAN) network with ID 10, supporting both static and dynamic multicast configurations.

## Topology
- **Router 1** (zoukaddo-1_g): Gateway with IP 10.0.0.1 (underlay) and bridge br0
- **Router 2** (zoukaddo-2_g): Gateway with IP 10.0.0.2 (underlay) and bridge br0  
- **Host 1** (zoukaddo-1_host): End device with IP 192.168.10.1 (overlay)
- **Host 2** (zoukaddo-2_host): End device with IP 192.168.10.2 (overlay)

## VXLAN Configuration
- **VXLAN ID**: 10
- **VXLAN Name**: vxlan10
- **Bridge Name**: br0
- **Multicast Group**: 239.1.1.1 (for dynamic configuration)
- **VXLAN Port**: 4789 (standard VXLAN port)

## Network Addressing
### Underlay Network (Physical)
- Router 1: 10.0.0.1/24
- Router 2: 10.0.0.2/24

### Overlay Network (VXLAN)
- Host 1: 192.168.10.1/24
- Host 2: 192.168.10.2/24

## Configuration Files

### Routers (Gateways)
- `_zoukaddo-1_g/vxlan-setup.sh`: Router 1 VXLAN and bridge configuration
- `_zoukaddo-2_g/vxlan-setup.sh`: Router 2 VXLAN and bridge configuration

Both routers support:
1. **Static VXLAN**: Point-to-point tunnel between routers
2. **Dynamic Multicast VXLAN**: Uses multicast group 239.1.1.1 for dynamic discovery

### Hosts
- `_zoukaddo-1_host/config.txt`: Host 1 overlay network configuration
- `_zoukaddo-2_host/config.txt`: Host 2 overlay network configuration

## Docker Images
- `Dockerfile.host`: Alpine-based container for host machines
- `Dockerfile.router`: Alpine-based container for router/gateway machines

Both images include:
- iproute2: For IP configuration and VXLAN management
- bridge-utils: For bridge configuration
- iputils: For network testing (ping, etc.)

## Testing the Setup

### 1. Verify VXLAN Creation
```bash
ip link show type vxlan
```

### 2. Check Bridge Configuration
```bash
brctl show
```

### 3. View MAC Address Table
```bash
brctl showmacs br0
```

### 4. Test Connectivity
From Host 1:
```bash
ping 192.168.10.2
```

From Host 2:
```bash
ping 192.168.10.1
```

### 5. Monitor VXLAN Traffic
```bash
tcpdump -i eth1 port 4789
```

## Multicast Group Verification
To see the multicast group membership:
```bash
ip maddr show dev eth1
```

## Expected Results
- Hosts should be able to communicate through the VXLAN overlay
- Traffic between hosts will be encapsulated in VXLAN headers
- Multicast group 239.1.1.1 should be visible in the configuration
- MAC learning should occur in the bridge tables