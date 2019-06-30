sudo apt install nfs-common -y
dt=`date '+(%d-%m-%Y_%H-%M-%S)'`

read -p "Enter the password for file shares: " CIFS_PASS

FSTAB_SKEL="skel/fstab"

sudo cp /etc/fstab /etc/fstab.${dt}
true | sudo tee /etc/fstab > /dev/null 2>&1

cat "${FSTAB_SKEL}" | sed 's/CIFS_PASS/'${CIFS_PASS}'/g' | while read row
do
    dir=`echo ${row} | awk '{print $2}'`
	sudo mkdir -p ${dir}
    if [ $? -eq 0 ]; then
        echo "${row}" | sudo tee -a /etc/fstab > /dev/null 2>&1
        echo "Added: ${row}"
    else
        echo "Failed to create directory: ${dir}"
    fi
done

sudo mount -a