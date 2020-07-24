#!/usr/bin/env bash

# Wait for network interface to come online
while ! ip link show dev eth1; do
  sleep 1
done

# Enable IP forwarding and NAT
sysctl -q -w net.ipv4.ip_forward=1
sysctl -q -w net.ipv4.conf.eth1.send_redirects=0
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

# Wwitch the default route to eth1
ip route del default dev eth0

# Wait for network connection
curl --retry 10 http://www.example.com

# Re-establish connections
systemctl restart amazon-ssm-agent.service
