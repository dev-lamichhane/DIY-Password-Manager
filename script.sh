#!/usr/bin/bash

# Determining whether we're working with apt or pacman

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

# Downloading gpg and xclip if you don't already have them. debian downloads a million packages for some reason. It's on you for using debian ;)
# I also tried wl-clipboard, but it doesnt work as well. Even if you're using wayland, try xclip, it might still work!
$command $packages

# Creating gpg keypair if you don't already have them. Extracting email if you already have keys
# If you have multiple sets of keys, this program will use the first one

key_status=`gpg --list-secret-key | grep sec | awk '{print $1}' `
echo "key status is $key_status"
if [ -z $key_status ]; then
	clear
	echo "You do not have a gpg keypair, let's generate one!"
	echo "Please follow instructions to create a gpg keypair."
	echo "Write down the name, email and passphrase you used to create the keypair!!"
	read -p "Press enter to start gpg key generation. You can exit this script anytime by pressing Ctrl+C."
	gpg --generate-key
else
	#extracting the email associated with the first keypair
	email=`gpg --list-secret-key | grep uid | head -1 | awk '{print $NF}'| tr -d "<>" `
	echo "Looks like you already have a keypair associated with $email. Let's use it to encrypt your passwords."
	read -p "Please press enter if you agree. You can exit this script anytime by pressing Ctrl+C."
fi

clear

# Creating a hidden directory to story encrypted passwords
echo "Let's create an hidden directory (.mypasswords)in your home directory to store encrypted passwords."
mkdir ~/.mypasswords

if [ $? > 0 ]; then
	read -p "~/.mypasswords exists. Overwrite ? Enter to continue, type 'n' to exit this script" ans
	if [ ans > "n" ]; then
		exit
	fi
	rm -rf ~/.mypasswords
	mkdir ~/.mypasswords
fi

# Adding a function ~/.bashrc that writes passwords to ~/.mypasswords
echo '
# Use this function to save your passwords
pass(){
	read -p "Enter a keyword to remember your passwords by: " keyword
	read -p "Enter the login ID for your password (eg. email address, username): " username
        read -p "Enter the password for this ID: " password
	
	email=$( gpg --list-secret-key | grep uid | head -1 | awk "{print \$NF}"| tr -d "<>" )

	gpg -e -r $email -o ~/.mypasswords/$keyword <<< "$username	$password"
}' >> ~/.bashrc

#realoding the bashrc
source ~/.bashrc


