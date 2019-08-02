find . -name "*.sh" -exec chmod 755 {} \;

./install-fstab.sh
./install-transmission.sh
./install-couchpotato.sh
sudo apt-get install exiftool -y
