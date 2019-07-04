#!/bin/bash

# bootstrap-container.sh

read -p "Enter the password for viking: " USER_PASS

echo "useradd -m -G sudo -s /bin/bash viking && echo -e '${USER_PASS}\n${USER_PASS}' | passwd viking" | pct enter 1022