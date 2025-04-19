sudo apt install -y lld

CONFIG='
[build]\n
rustflags = [
  "-C", "link-arg=-fuse-ld=lld",
]\n

'

echo -e $CONFIG >> ~/.cargo/config


