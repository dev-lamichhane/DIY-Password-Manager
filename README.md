#Setup
Use this script only once to setup a DIY password manager for your personal use. It uses GPG/GnuPG and xclip to encrypt, decrypt and copy decrypted password to you clipboard for one time use only. Follow the instructions as the script goes along to set it up.

#Saving passwords
Once the setup is complete type `put` in you terminal and enter your username, password, and a keyword (optional).

#Extracting passwords for use
Saved passwords can be copied to the clipboard with the command `get keyword` or `get username` (in case you skipped on the keyword)

#Backup
Passwords are saved in ~/.mypasswords for retrival and a backup of all pasword files is save as ~/Documents/.mypasswordsbakcup/backup.tar.gz
