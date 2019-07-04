# source common/functions.sh

CON_ID=1022

pct status ${CON_ID} 
if [ $? -eq 0 ]; then
    echo "Stopping and Destroying container"
    
    pct stop ${CON_ID} && pct destroy ${CON_ID}
    
    echo "Done"
fi

echo "Creating new container"

pct create ${CON_ID} seagate:vztmpl/ubuntu-19.04-standard_19.04-1_amd64.tar.gz \
--description sickrage2 \
-net0 name=eth0,bridge=vmbr0,gw=192.168.2.8,ip=192.168.2.41/24,type=veth \
--hostname sickrage2 \
--cores 1               \
--force                 \
--memory 512            \
--onboot 1              \
--ostype ubuntu         \
--password viking       \
--start                 \
--storage local-zfs     \
--unprivileged 0

pct start ${CON_ID}

read -p "Enter the password for viking: " USER_PASS

echo "useradd -m -G sudo -s /bin/bash viking && echo -e '${USER_PASS}\n${USER_PASS}' | passwd viking" | pct enter ${CON_ID}
echo "echo '0 3 * * * apt update && apt upgrade -y >/dev/null 2>&1 ' | crontab" | pct enter ${CON_ID}
echo "apt-get update && apt-get upgrade -y" | pct enter ${CON_ID}