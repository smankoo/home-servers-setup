sudo apt-get install git-core python python-cheetah -y
sudo apt install python-pip -y

USER=`whoami`
cd ~

if [ -d ".sickrage" ]; then
    sudo mv .sickrage .sickrage_old
fi

git clone https://github.com/sickrage/sickrage.git .sickrage

pip install -r .sickrage/requirements.txt

if [ -f /etc/init.d/sickrage ]; then
    sudo rm /etc/init.d/sickrage
fi
if [ -f /etc/default/sickrage ]; then
    sudo rm /etc/default/sickrage
fi

sudo update-rc.d -f sickrage remove

cd ~/.sickrage/runscripts
sudo cp ~/.sickrage/runscripts/init.ubuntu /etc/init.d/sickrage
sudo chmod +x /etc/init.d/sickrage

echo "SR_HOME=/home/${USER}/.sickrage/
SR_DATA=/home/${USER}/.sickrage/
SR_USER=${USER}" | sudo tee /etc/default/sickrage > /dev/null 2>&1

sudo chmod +x /etc/default/sickrage

sudo update-rc.d sickrage defaults


sudo service sickrage start
