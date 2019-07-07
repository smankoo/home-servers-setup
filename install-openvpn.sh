wget https://git.io/vpn -O openvpn-install.sh
chmod 755 openvpn-install.sh

echo "#!/bin/bash
mkdir /dev/net
mknod /dev/net/tun c 10 200
chmod 0666 /dev/net/tun" | sudo tee /usr/sbin/tunscript.sh

sudo chmod +x /usr/sbin/tunscript.sh

echo "/usr/sbin/tunscript.sh || exit 1                                                          
exit 0" | sudo tee /etc/rc.local

sudo ./openvpn-install.sh

sudo /usr/sbin/tunscript.sh
