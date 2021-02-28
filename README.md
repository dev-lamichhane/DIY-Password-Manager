## Setup  
Use this script only once to setup a DIY password manager for your personal use. It uses GPG/GnuPG and xclip to encrypt, decrypt and copy decrypted password to you clipboard for one time use only. Follow the instructions as the script goes along to set it up.  

## Saving and retriving passwords
Once the setup is complete type `put` in you terminal and enter your username, password, and a keyword (optional). Saved passwords can be copied to the clipboard with the command `get keyword` or `get username` (in case you skipped on the keyword). Copied passwords will be available for pasting only once.  
### Example  
enter myfakeemail@gmail.com as username  
enter myfakepassword as password  
enter gmail as the keyword (this is optional) 

decrypt and copy the password with command `get gmail` on your terminal  
if you skipped on the keyword, copy password with command `get myfakeemail@gmail.com`  
 
## Backup  
Passwords are saved in ~/.mypasswords for retrival and a backup of all pasword files is save as ~/Documents/.mypasswordsbakcup/backup.tar.gz

# Disclaimer  
Use at your own risk!
