# generate init ram fs for kernel
sudo update-initramfs -c -k $(uname -r)

# see all kernels
dpkg -l | tail -n +6 | grep -E 'linux-image-[0-9]+' | grep -Fv $(uname -r)

# check boot volume load
df -h | grep boot

# delete actual directory
sudo update-initramfs -d -k 5.8.0-33-generic

