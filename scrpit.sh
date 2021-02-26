#!/usr/bin/bash

deb=`ls /etc | grep apt | head -1`
arch=`ls /etc | grep pacman | head -1 `

if [ ! -z $deb ]; then
	echo "You're using a debian based distro!"
fi

if [ ! -z $arch ]; then
	echo "You're using an arch based distro!"
fi

