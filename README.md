cryptstorage
============

Create an encrypted volume contained in a regulr file. It also mount and unmount it for you. A simple solution to manage encrypted volumes

INFO
CryptStorage is a couple of scripts by Giovanni Santostefano
(http://twocentssecurity.wordpress.com) that allows the
user to create, mount and unmount an encrypted volume
stored in a common file with LUKS specifics!

You can use the 
cryptstorage_create.sh
script and follow the instructions to generate a file and next
use the script
cryptstorage_mount.sh 
to mount this file as a regular volume.
You can also use the
cryptdevice_create.sh
script to create an encrypted volume (eg. usb pen or sd card or hd partition)

You can copy your volume to an external disk or hide as you
whish! Remember that this is a volume but in fact you can
treat it as a regular file!!!

To run these scripts and to operate into the volume you need
necessarily the root privileges... no way to avoid this! :(

At this stage the program is really rubbish, it laks of
normal controls of successufl commands and other things, so
use it at your own risk!
Next I will stabilize and rewrite most of the code.
...
next! :)

Have a nice encrypted day!
