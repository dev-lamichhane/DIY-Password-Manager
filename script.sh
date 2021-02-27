#!/usr/bin/bash

apt=`ls /etc | grep apt | head -1`
pacman=`ls /etc | grep pacman | head -1 `

if [ ! -z $apt ]; then
	distro="debian"
elif
	[ ! -z $pacman ]; then
	distro="arch"
fi


if [ -z $apt ] && [ -z $pacman ]; then
	echo "This script is only for Arch or Debian based distros. Bye!!"
else 
	echo "You're using $distro!"
fi
