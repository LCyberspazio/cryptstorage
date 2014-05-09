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
echo "Use this script to create encrypted devices"
echo "like usb pen. eg /dev/sd..."
echo
echo "With this script you can do lots of damage!"
echo "Check the script first and then use it if you know"
echo "what to do. Otherwise CTRL+C"
echo
echo "[ Press ENTER to continue]"
read


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

#watch up the /dev table
clear
echo "Take a look at your disk structure"
echo "and choose the device you want to format"
echo
echo "[ Press ENTER to continue]"
read
clear
fdisk -l | grep /dev/sd
echo
echo "[ Press ENTER to continue]"
read


#enter the filename
echo
echo
echo "Specify a device where you want to create the volume"
echo "BEWARE! All device data will wiped out"
echo
echo -n "Enter the filename of the volume: "
read fnamevol

if [[ $fnamevol =~ /dev/sd[a-z][1-9] ]]
then
    echo "PATH WELL FORMED"
else
    echo
    echo "THIS IS NOT A DEVICE!!!"
    echo "What's with you!"
    echo "If I have not blocked the script now"
    echo "You'll had the hard disk filled of random data"
    echo
    echo "Incredible..."
    echo "Use device like /dev/sdc56... for example"
    exit 10
fi

if [ -e $fnamevol ]
then
  echo "device exists"
else
  echo
  echo
  echo "ERROR!!!"
  echo "Device not found!"
  exit 11
fi

clear
echo "Do you want to fill the device with random data?"
echo
echo "Randomizing the device enforce the cryptography"
echo "because there's no hint on where data in the volume"
echo "ends."
echo -n "Enter Y/N: "
read ranchoice

if [[ $ranchoice =~ ^[Yy] ]]
then
    echo "Randomizing volume data"
    echo "Take a coffee... it will take long time"
    echo "on 2GB usb2 volume it may take half an hour"
    dd if=/dev/urandom of=$fnamevol
    echo "Volume random filled"
else
    echo "No device randomization... NSA will own you! :D"
    echo "ok... they'll own you in any case... "
fi


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
