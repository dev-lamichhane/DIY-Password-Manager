#!/usr/bin/bash

apt=`ls /etc | grep apt | head -1`
pacman=`ls /etc | grep pacman | head -1 `

if [ ! -z $apt ]; then
	distro="debian"
	command="sudo apt install --no-install-recommends"
	packages="gpg xclip"
elif
	[ ! -z $pacman ]; then
	distro="arch"
	command="sudo pacman -S --needed"
	packages="gnupg xclip"
fi


if [ -z $apt ] && [ -z $pacman ]; then
	echo "This script is only for Arch or Debian based distros. Bye!!"
	exit $?
else 
	echo "You're using $distro!"
fi

$command $packages
