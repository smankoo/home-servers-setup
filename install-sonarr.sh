# Enable apt-get to install from https sources
sudo apt-get install apt-transport-https -y

# install mono
sudo apt install -y gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update

# install sonarr
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493
echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list

sudo apt update && \
sudo apt install -y nzbdrone 

# install as a service
sudo cp skel/sonarr-init.d.txt /etc/init.d/nzbdrone
sudo chmod +x /etc/init.d/nzbdrone
sudo update-rc.d nzbdrone defaults
sudo service nzbdrone start
