pct stop 102 
pct destroy 102

pct create 102 seagate:vztmpl/ubuntu-19.04-standard_19.04-1_amd64.tar.gz --description sickrage2 -net0 name=eth0,bridge=vmbr0,gw=192.168.2.8,ip=192.168.2.30/24,type=veth \
--hostname sickrage2 \
--cores 1               \
--features fuse=1       \
--force                 \
--memory 512            \
--onboot 1              \
--ostype ubuntu         \
--password viking       \
--start                 \
--storage local-zfs     \
--unprivileged 0

pct start 102

read -p "Enter the password for viking: " USER_PASS

echo "useradd -m -G sudo -s /bin/bash viking && echo -e '${USER_PASS}\n${USER_PASS}' | passwd viking" | pct enter 102

# find Home\ Data\ Center\ Stuff/ -name "*.sh" -exec chmod 755 {} \;
