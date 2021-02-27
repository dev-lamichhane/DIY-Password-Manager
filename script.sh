#!/usr/bin/bash
#
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

key_status=`gpg --list-secret-key | grep sec | awk '{print $1}' `
echo "key status is $key_status"
if [ -z $key_status ]; then
	clear
	echo "You do not have a gpg keypair, let's generate one!"
	echo "Please follow instructions to create a gpg keypair."
	echo "Write down the name, email and passphrase you used to create the keypair!!"
	read -p "Press enter to start gpg key generation."
	gpg --generate-key
else
	name=`gpg --list-secret-key | grep uid | head -1 | awk '{print $NF}' `
	echo "Looks like you already have a keypair associated with $name. Let's use it to encrypt your passwords."
	read -p "Please press enter if you agree. You can exit this script anytime by pressing Ctrl+C."
fi


