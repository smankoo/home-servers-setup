sudo apt install transmission-daemon -y

daemon_status=`systemctl is-active transmission-daemon`

SETTINGS_FILE="skel/transmission-settings.json"

if [ "${daemon_status}" = "active" ]; then
    sudo service transmission-daemon stop
    echo "Transmission daemon stopped"
fi

if [ -f "${SETTINGS_FILE}" ]; then
    cat "${SETTINGS_FILE}" | sudo tee /etc/transmission-daemon/settings.json > /dev/null 2>&1
    cp -f "${SETTINGS_FILE}" /home/viking/.config/transmission-daemon/settings.json
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

daemon_status=`systemctl is-active transmission-daemon`

daemon_status=`systemctl is-active transmission-daemon`
if [ "${daemon_status}" = "active" ]; then
    echo "Transmission daemon started"
else
    echo "Failed to start transmission daemon"
fi