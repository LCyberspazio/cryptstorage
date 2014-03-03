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
MPOINT=/mnt/cryptvol

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

#test for mount point
if [ -d "$MPOINT" ]
then
  echo "mount point found!"
else
  echo "Creating mount point"
  mkdir $MPOINT
fi

clear
#enter the filename
echo "Enter the file name of the volume created with"
echo "cryptstorage_create.sh script"
echo
echo -n "Enter the filename of the volume: "
read fnamevol

if [ -e "$fnamevol" ]
then
  echo "voume exists!"
else
  echo
  echo
  echo "ERROR!!!"
  echo "Filename not found!"
  exit 6
fi

clear
echo "Defining loop device"
losetup $LOOP_DEV $fnamevol
echo
echo "Opening the device"
cryptsetup luksOpen $LOOP_DEV $CRYPT_NAME
echo
echo "mounting the device in the $MPOINT directory"
mount  /dev/mapper/$CRYPT_NAME $MPOINT/
clear
echo "Encrypted volume mounted in $MPOINT"
echo "To write on this directory use root permissions"
echo 
echo "When you finish to use this volume please hit ENTER"
echo "to unmount and close all the devices!"
echo "IT'S IMPORTANT"
read
echo
echo "OK! Almost done! Let's close everything"
umount /dev/mapper/$CRYPT_NAME
cryptsetup luksClose /dev/mapper/$CRYPT_NAME
losetup -d $LOOP_DEV
echo 
echo
echo "Have a nice day!"