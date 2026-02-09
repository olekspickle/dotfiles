#!/bin/bash

# Security
# List your MACs address
ip addr show eth0 | grep ether | awk '{print $2}'

# SSH safe algorithms patch
yum update *ssh* -y
cat <<'EOF' >> /etc/ssh/sshd_config
Ciphers aes128-ctr,aes192-ctr,aes256-ctr
KexAlgorithms ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256
MACs hmac-sha2-256,hmac-sha2-512
EOF
systemctl restart sshd.service

# Show UDID of iPhone
lsusb -s :`lsusb | grep iPhone | cut -d ' ' -f 4 | sed 's/://'` -v | grep iSerial | awk '{print $3}'


# ======  PENTEST ====
#
# HOTSPOT
nmcli device wifi hotspot con-name my-hotspot ssid my-hotspot band bg password lmaofubar
# Create a connection
nmcli connection add type wifi ifname '*' con-name my-hotspot autoconnect no ssid my-local-hotspot
# Put it in Access Point
nmcli connection modify my-hotspot 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
# Set a WPA password (you should change it)
nmcli connection modify my-hotspot 802-11-wireless-security.key-mgmt wpa-psk 802-11-wireless-security.psk myhardpassword
# Enable it (run this command each time you want to enable the access point)
nmcli connection up my-hotspot
# Disable
nmcli connection down my-hotspot
# after this on linux you could experience some problems with network interface
sudo service network-manager restart

