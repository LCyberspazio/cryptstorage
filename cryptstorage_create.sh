#! /bin/bash

#CryptStorage  Copyright (C) 2013  Giovanni Santostefano
#This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
#This is free software, and you are welcome to redistribute it
#under certain conditions; type `show c' for details.

#Cryptstorage allow the user to create, mount and unmount
#an encrypted storage maintained in a file!
#Beware! It requires always root privileges!

#THIS SCRIPT CAN SERIOUSLY DAMAGE YOUR SYSTEM!
#USE IT AT YOUR OWN RISK!
#HOW CAN I SAY YOU... IF THIS FUCK YOUR SYSTEM
#THIS IS YOUR ONLY PROBLEM! 
#NO COSPIRACY ;)

LOOP_DEV=/dev/loop0
CRYPT_NAME=gscryptstorage

clear
echo "CryptStorage"
echo "A script for LUKS encrypted storage"
echo "by Giovanni Santostefano"
echo "http://letteredalcyberspazio.wordpress.com"
echo
echo


if [ -e "$LOOP_DEV" ]
then
  echo "Loop device checked!"
else
  echo
  echo
  echo "ERROR!!!"
  echo "Please, edit the script with a valid loop device"
  exit 1
fi


if [ -e "/sbin/cryptsetup" ]
then
  echo "cryptsetup installed!"
else
  echo
  echo
  echo "ERROR!!!"
  echo "Cryptsetup not found!"
  exit 2
fi


clear
#please give me root
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   echo "So, if you don't want root on the system"
   echo "use sudo or some other shit"
   exit 9
fi


clear
#enter the number of megabytes of the new volume
echo -n "Enter the number of MBytes of the new volume: "
read mbyte

clear
#enter the filename
echo "Specify a filename where you want to create the volume"
echo "BEWARE! An existing filename will wipe all the data of"
echo "the file!!!!!"
echo
echo -n "Enter the filename of the volume: "
read fnamevol

clear
echo "Creating the volume in the file"
dd if=/dev/urandom of=$fnamevol bs=1M count=$mbyte
echo "Volume created"
echo
echo "Defining loop device"
losetup $LOOP_DEV $fnamevol
echo "Formatting as luks volume"
cryptsetup -s 256 -y luksFormat $LOOP_DEV
echo
echo "Opening the device"
cryptsetup luksOpen $LOOP_DEV $CRYPT_NAME
echo
echo "Formatting the crypt device as FAT32"
mkdosfs /dev/mapper/$CRYPT_NAME
echo
echo "OK! Almost done! Let's close everything"
cryptsetup luksClose /dev/mapper/$CRYPT_NAME
losetup -d $LOOP_DEV
echo 
echo
echo "Yatta!!! storage created!"
echo "Use"
echo "cryptstorage_mount storagename"
echo "To mount the device"