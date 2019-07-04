sudo apt-get update 
sudo apt-get install git python python3 python-cheetah python-pip python3-pip -y

USER=`whoami`
cd ~

if [ -d ".sickrage" ]; then
    sudo mv .sickrage .sickrage_old
fi

git clone https://github.com/sickrage/sickrage.git .sickrage

pip3 install -r .sickrage/requirements.txt

if [ -f /etc/init.d/sickrage ]; then
    sudo rm /etc/init.d/sickrage
fi
if [ -f /etc/default/sickrage ]; then
    sudo rm /etc/default/sickrage
fi

sudo update-rc.d -f sickrage remove


# There seems to be a bug. Python version specified in /etc/default/sickrage is not used
# while starting the service. So the python version needs to be "hardcoded"
sed -i.bak 's/python2.7/python3.7/' ~/.sickrage/runscripts/init.ubuntu

sudo cp ~/.sickrage/runscripts/init.ubuntu /etc/init.d/sickrage
sudo chmod +x /etc/init.d/sickrage

echo "SR_HOME=/home/${USER}/.sickrage/
SR_DATA=/home/${USER}/.sickrage/
SR_USER=${USER}
PYTHON_BIN=/usr/bin/python3.7" | sudo tee /etc/default/sickrage > /dev/null 2>&1

sudo chmod +x /etc/default/sickrage

sudo update-rc.d sickrage defaults

sudo service sickrage start
