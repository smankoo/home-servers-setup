sudo apt-get install git python python-cheetah -y

USER=`whoami`
cd ~

if [ -d ".couchpotato" ]; then
    sudo mv .couchpotato .couchpotato_old
fi

git clone --branch imdb-indian-trending https://github.com/smankoo/CouchPotatoServer.git .couchpotato

# sudo apt install python-pip -y
# pip install -r .couchpotato/requirements.txt


if [ -f /etc/init.d/couchpotato ]; then
    sudo rm /etc/init.d/couchpotato
fi
if [ -f /etc/default/couchpotato ]; then
    sudo rm /etc/default/couchpotato
fi

sudo update-rc.d -f couchpotato remove

sudo cp ~/.couchpotato/init/ubuntu /etc/init.d/couchpotato
sudo chmod +x /etc/init.d/couchpotato


echo "CP_HOME=/home/${USER}/.couchpotato/
CP_DATA=/home/${USER}/.couchpotato/
CP_USER=${USER}
CP_PIDFILE=/home/${USER}/.couchpotato/couchpotato.pid" | sudo tee /etc/default/couchpotato > /dev/null 2>&1

sudo chmod +x /etc/default/couchpotato

sudo update-rc.d couchpotato defaults

sudo service couchpotato start
