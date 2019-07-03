sudo apt-get install git python3 python-cheetah python3-pip -y

PYTHON_BIN=`which python`
PYTHON3_BIN=`which python3`

if [ "${PYTHON_BIN}" != "" ] && [ "${PYTHON3_BIN}" != "" ] && [ -e "${PYTHON_BIN}" ]; then
	if [ -e "${PYTHON3_BIN}" ]; then
		if [ -L "${PYTHON_BIN}" ]; then
			sudo rm "${PYTHON_BIN}"
		elif [ -f "${PYTHON_BIN}" ]; then
			sudo mv "${PYTHON_BIN}" "${PYTHON_BIN}".`date '+%Y-%m-%d_%H-%M-%S'`
		fi
		sudo ln -s "${PYTHON3_BIN}" "${PYTHON_BIN}"
		echo "${PYTHON_BIN} now points to ${PYTHON3_BIN}"
	fi
fi
 

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

cd ~/.sickrage/runscripts
sudo cp ~/.sickrage/runscripts/init.ubuntu /etc/init.d/sickrage
sudo chmod +x /etc/init.d/sickrage

echo "SR_HOME=/home/${USER}/.sickrage/
SR_DATA=/home/${USER}/.sickrage/
SR_USER=${USER}" | sudo tee /etc/default/sickrage > /dev/null 2>&1

sudo chmod +x /etc/default/sickrage

sudo update-rc.d sickrage defaults


sudo service sickrage start
