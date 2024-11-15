# generate init ram fs for kernel
# sudo update-initramfs -c -k $(uname -r)

# see all kernels
# dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r)

# check boot volume load
# df -h | grep boot

# delete actual directory
# sudo update-initramfs -d -k 5.8.0-33-generic

v="$(uname -r | awk -F '-virtual' '{ print $1}')"
echo "$v"

i="linux-headers-virtual|linux-image-virtual|linux-headers-generic-hwe-|linux-image-generic-hwe-|linux-headers-${v}|linux-image-$(uname -r)|linux-image-generic|linux-headers-generic"
echo "$i"

echo "To be deleted:"

dpkg --list | egrep -i 'linux-image|linux-headers' | awk '/ii/{ print $2}' | egrep -v "$i"

# sudo -i

apt --purge remove $(dpkg --list | egrep -i 'linux-image|linux-headers' | awk '/ii/{ print $2}' | egrep -v "$i")
