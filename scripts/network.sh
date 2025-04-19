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
# gobuster password authentication examples
function gobust() {
    gobuster -e -u $1 -w wordlist
}

# NMAP
# This command will perform a stealth SYN scan (-sS) using a decoy list of 10 random IP addresses (-D RND:10)
# and using your IP address as a source IP address (ME).
# It will not ping the target (-Pn) and will run a script to check for vulnerabilities
# (--script vuln) and save the output to a file called scan_result.txt (-oN scan_result.txt).
function nmap-stealth-syn() {
    nmap -sS -D RND:10,ME -Pn --script vuln -oN scan_result.txt <target_IP>
}

# Aggressive scan to determine host OS
function nmap-aggressive() {
    nmap -Pn -A -T4 $1/24
}

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

