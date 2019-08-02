# sudo apt update && \
# sudo apt install -y mono-devel ca-certificates-mono && \
# sudo apt install -y libcurl4-openssl-dev &&


wget https://github.com/Jackett/Jackett/releases/download/v0.11.554/Jackett.Binaries.LinuxAMDx64.tar.gz && \
gunzip -xvfz Jackett.Binaries.LinuxAMDx64.tar.gz && \
cd Jackett && \ 
sudo ./install_service_systemd.sh
