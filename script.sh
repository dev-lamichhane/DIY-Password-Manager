#!/usr/bin/bash

# encrypt and save passwords with the command 'put'
# enter username, password and optionally a keyword to remember the username/password pair
# decrypt and copy your desired password with the command 'get username/keyword'
# example: enter myfakeemail@gmail.com as username, myfakepassword as password and gmail as the keyword for the 'put' command
#	   decrypt and copy the password with command 'get gmail' on your terminal 

# encrypted passwords are saved in ~/.mypasswords
# a backup of that directory is saved at ~/Documents/.mypasswordsbakcup
# the backup is updated every time you add a new password
# Use at your own risk!



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
	read -p "~/.mypasswords already xists. Overwrite ? Enter to continue, hit any other key+Enter to exit" ans
	if [ ! -z $ans ]; then
		exit
	fi
	rm -rf ~/.mypasswords
	mkdir ~/.mypasswords
fi

# Creating a directory in ~/Documents to backup you encrypted passwords
# Everytime you push a passowrd to ~/.mypasswords, the backup will be updated

mkdir ~/Documents/.mypasswordsbackup

if [ $? > 0 ]; then
	read -p "~/Documents/.mypasswords exists. Overwrite ? Enter to continue, hit any other key+Enter to exit" answ
	if [ ! -z $answ  ]; then
		exit
	fi
	rm -rf ~/.mypasswordsbackup
	mkdir ~/.mypasswordsbackup
fi



# Adding a function ~/.bashrc that writes passwords to ~/.mypasswords
echo '
# Use this function to save your passwords
put(){
	read -p "Enter the login ID for your password (eg. email address, username): " username
        read -p "Enter the password for this ID: " password
	read -p "Enter a short keyword for this userID/password pair (optional): " keyword

	email=$( gpg --list-secret-key | grep uid | head -1 | awk "{print \$NF}"| tr -d "<>" )

	if [ -z $keyword ]; then
		filename=$username
	else
		filename=$keyword
	fi


	gpg -e -r $email -o ~/.mypasswords/$filename <<< "$username	$password"

	# Backing passwords up

	tar -zcvf ~/Documents/.mypasswordsbackup/backup.tar.zg ~/.mypasswords
}' >> ~/.bashrc

# Adding a function to ~/.bashrc that decrypts and copies your password to the clipboard
# The copied password will be pastable only once

echo '
# Use this function to decrypt and copy your desired password to the clipboard
# This function will take one argument ie the keyword/ID for you desired passworid

get(){
	gpg -d ~/.mypasswords/$1 | awk "{print \$2}" | xclip -l 1
}

' >> ~/.bashrc


# realoding the bashrc
# you should be good to go!

source ~/.bashrc

echo "You are all set up!"
