sudo apt install nfs-common -y
dt=`date '+%d-%m-%Y_%H-%M-%S'`

# read -p "Enter the password for file shares: " CIFS_PASS

FSTAB_SKEL="skel/fstab"

if [ ! -f /etc/fstab.orig ]; then
    sudo cp /etc/fstab /etc/fstab.orig
fi

sudo cp /etc/fstab /etc/fstab.${dt}
# true | sudo tee /etc/fstab > /dev/null 2>&1

sudo cp /etc/fstab.orig /etc/fstab

grep . "${FSTAB_SKEL}" | grep -v "#" | while read row
do
    dir=`echo ${row} | awk '{print $2}'`
    echo "row is: ${row}"
    echo "dir is: ${dir}"
	sudo mkdir -p ${dir}
    if [ $? -eq 0 ]; then
        echo "${row}" | sudo tee -a /etc/fstab > /dev/null 2>&1
        echo "Added: ${row}"
    else
        echo "Failed to create directory: ${dir}"
    fi
done

sudo mount -a