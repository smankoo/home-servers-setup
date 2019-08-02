sudo apt install git -y
rm -rf ~/home-servers-setup
git clone https://github.com/smankoo/home-servers-setup.git && \
cd home-servers-setup && \
chmod 755 *.sh &&
./install-fstab.sh
sudo timedatectl set-timezone America/Toronto
