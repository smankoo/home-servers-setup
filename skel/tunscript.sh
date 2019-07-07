#!/bin/bash

# /usr/sbin/tunscript.sh 

mkdir /dev/net
mknod /dev/net/tun c 10 200
chmod 0666 /dev/net/tun

