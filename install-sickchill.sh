sudo apt-get install git-core python python-cheetah -y

USER=`whoami`
cd ~

if [ -d ".sickchill" ]; then
    sudo mv .sickchill .sickchill_old
fi

git clone https://github.com/SickChill/SickChill.git .sickchill

if [ -f /etc/init.d/sickchill ]; then
    sudo rm /etc/init.d/sickchill
fi
if [ -f /etc/default/sickchill ]; then
    sudo rm /etc/default/sickchill
fi

sudo update-rc.d -f sickchill remove

cd ~/.sickchill/runscripts
sudo cp ~/.sickchill/runscripts/init.ubuntu /etc/init.d/sickchill
sudo chmod +x /etc/init.d/sickchill


echo "SR_HOME=/home/${USER}/.sickchill/
SR_DATA=/home/${USER}/.sickchill/
SR_USER=${USER}" | sudo tee /etc/default/sickchill > /dev/null 2>&1

sudo chmod +x /etc/default/sickchill

sudo update-rc.d sickchill defaults


sudo service sickchill start
