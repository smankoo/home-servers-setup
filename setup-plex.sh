sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install curl -y
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

sudo apt install plexmediaserver -y

