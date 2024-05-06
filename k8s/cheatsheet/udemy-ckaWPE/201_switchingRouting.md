Switching Routing
=================

- `ip link` --> Get a list of **Interfaces**
- `ip addr add 192.168.1.10/24 dev eth0` --> Set IP on a device
- `route` --> See kernel **Routing Table**
- `ip route add 192.168.2.0/24 via 192.168.1.1` --> Set route entry
- `ip route add default via 192.168.1.1` --> Add **Default Route** Entry
   - Can also be achieved by `ip route add 0.0.0.0 via 192.168.1.1`
## How to setup a *Linux* as a *Router*
- By default packet aren't forwarded from one interface to another on a *linux* system
   - Security reason
   - But can be changed
   - Whether a host can forward packets between interfaces in governed by a setting in `/proc/sys/net/ipv4/ip_forward`
      - Setting the value to `1` would allow for forwarding packets
      - But it ain't persistent across *reboots*, to make it persistent it should also be changed in `/etc/sysctl.conf`
