#!/usr/bin/bash

apt=`ls /etc | grep apt | head -1`
pacman=`ls /etc | grep pacman | head -1 `

if [ ! -z $apt ]; then
	distro="debian"
fi

if [ ! -z $pacman ]; then
	distro="arch"
fi

echo "You're using $distro!"

