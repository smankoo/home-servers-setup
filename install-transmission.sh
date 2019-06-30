sudo apt install transmission-daemon -y

daemon_status=`systemctl is-active transmission-daemon`

SETTINGS_FILE="skel/transmission-settings.json"

if [ "${daemon_status}" = "active" ]; then
    sudo service transmission-daemon stop
    echo "Transmission daemon stopped"
fi

if [ -f "${SETTINGS_FILE}" ]; then
    cat "${SETTINGS_FILE}" | sudo tee /etc/transmission-daemon/settings.json > /dev/null 2>&1
    echo "Standard Trnsmission settings applied."
else
    echo "Missing settings.json. Unable to apply standard Transmission settings."
fi

if [ ! -d "/etc/systemd/system/transmission-daemon.service.d" ]; then
    sudo mkdir -p /etc/systemd/system/transmission-daemon.service.d
fi

echo "[Service]
User=viking" | sudo tee /etc/systemd/system/transmission-daemon.service.d/run-as-user.conf > /dev/null 2>&1
sudo systemctl daemon-reload
sudo service transmission-daemon start
echo "Transmission daemon started"

