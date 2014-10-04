#!/bin/sh
# Unix OS Sniffer and $adb setup by Firon
platform=`uname`;
ADB=$PWD"/Files/tools/adb";
FASTBOOT=$PWD"/Files/tools/fastboot";
MFASTBOOT=$PWD"/Files/tools/mfastboot";
cd "$(dirname "$0")"
if [ -z $(which adb) ]; then
	ADB=$PWD"/Files/tools/adb";
    FASTBOOT=$PWD"/Files/tools/fastboot";
    MFASTBOOT=$PWD"/Files/tools/mfastboot";
	if [ "$platform" == 'Darwin' ]; then
		ADB=$PWD"/Files/tools/adb.osx"
		FASTBOOT=$PWD"/Files/tools/fastboot.osx"
        MFASTBOOT=$PWD"/Files/tools/mfastboot.osx";

	fi
fi
chmod +x $ADB
chmod +x $FASTBOOT
chmod +x $MFASTBOOT

CLS='printf "\033c"'
# End section, thanks Firon (LEGACY)!

f_ROOT () {
unset ROOTSN
case $ROOTSN in
1) ROOTS=superuser ;;
2) ROOTS=supersu ;;
3) exit ;;
*) echo "\"$ROOTSN\" is not valid"
esac
echo "Choose a root program"
echo "Menu:"
echo
echo "1) Root and Install Superuser"
echo "2) Root and Install SuperSU"
echo "3) Do not root (quit)"
echo
echo
read ROOTSN
sleep 2
$CLS
sleep 1
echo "Pushing Recovery Script"
echo " ... "
sleep 1
echo " ..................... "
sleep 2
echo " ........................ "
sleep 1
$ADB push Files/root/$ROOTS/$ROOTS.zip /storage/sdcard0/$ROOTS.zip
$ADB push Files/root/command /cache/recovery/command
$ADB shell killall recovery
sleep 3
echo "Running automated recovery commands"
sleep 2
echo "Enjoy root :)"
echo "Press enter to continue"; read line
$ADB reboot
if [ -z $(which sudo 2>/dev/null) ]; then
	$ADB kill-server
else
	sudo $ADB kill-server
fi
f_BOOTMENU
}

f_FLASH () {
$CLS
$ADB reboot bootloader
echo
echo
echo
echo        Flashing $RECOVERY..
sleep 5
$FASTBOOT flash recovery Files/recovery/$RECOVERY.img
$CLS
echo
echo
echo "Please press the volume down key to scroll to recovery and the volume up key to select."
echo
echo "Press enter to continue when the recovery menu appears"; read line
f_ROOT
}

f_DEVICEMENU () {
$CLS
unset choice
case $choice in
1) RECOVERY=CWM && f_FLASH ;;
2) RECOVERY=TWRP && f_FLASH ;;
esac
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "         All in One Root and Recovery $VERSION"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo
echo "Menu:"
echo
echo "1) Root and Install ClockworkMod v6.0.5.0"
echo "2) Root and Install TeamWin Recovery Project v2.7.1.0"
echo
echo
echo
read choice
}

f_UNLOCK () {
$ADB reboot bootloader
sleep 6
$CLS
echo "if your phone is not displayed or it stays on waiting for device for too long then there was an error with the drivers or its not in fastboot"
echo "Serial number:  device state"
$FASTBOOT devices
echo
echo "go to http://bit.ly/UpVtsa and read the risks, continue to page 2"; read line 
echo "are you sure???? Do you know the risks? Are you willing to do this???"; read line
$FASTBOOT oem get_unlock_data
echo "enter this code on page 2 as shown in the example:"
echo "enter code on the website and press enter"; read line
echo "enter the key emailed to you here:"
read KEY
$FASTBOOT oem unlock $KEY
echo
echo "Press enter to continue"; read line
echo
echo
$FASTBOOT reboot
$CLS
$ADB "wait-for-device" devices
$CLS
echo
echo
echo
echo
echo
echo
echo
echo
echo "                   You need to enable usb debugging again"
echo
echo "                 Go to settings - applications - development"
echo
echo "                         Or in ICS and higher"
echo "             Settings - Developer Options - Android Debugging"
echo
echo "                       Or in 4.2 and higher"
echo " Settings - About phone - Tap build number 7 times - Use ICS instructions"
echo
echo
echo
echo "Press enter to continue"; read line
f_ROOT
}

f_LOCK () {
echo
echo
echo " So the custom life isn't for you? Press enter to continue."; read line
echo " Last chance to stick around."; read line
$ADB reboot bootloader
sleep 6
$FASTBOOT oem lock
echo " Unlocking..."; read line
sleep 10
echo "Your bootloader is now locked."; read line
echo
echo
echo
f_BOOTMENU
}

f_WARNING () {
$CLS
unset choice
while :
do
echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Please Read Carefully"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo "  Warning"
echo "  Warning"
echo "   THIS WILL WIPE ALL OF YOUR APPS, CONTACTS, GAMESAVES, etc..; EVERYTHING"
echo "                      INCLUDING YOUR INTERNAL SD CARD"
echo "   This will void whatever warranty is present on this device"
echo "  Warning"
echo "  Warning"; clear
echo
echo
case $choice in
Y) f_UNLOCK ;;
y) f_UNLOCK ;;
N) exit 0 ;;
n) exit 0 ;;
*) echo "\"$choice\" is not valid"
sleep 2
esac
echo
echo "Do you wish to continue?"
echo
echo
echo "Type Y/N"
echo
read choice
done
$CLS
f_UNLOCK
f_BOOTMENU
}


f_LOGO () {
echo
echo
echo " So you want to get rid of the contract on bootup?"
sleep 2
echo
echo
$CLS
$ADB reboot bootloader
sleep 6
$CLS
echo
echo "flashing logo"
$FASTBOOT flash logo Files/logo/peregrine_logo_mod.bin
sleep 3
echo "flashed logo!"
sleep 6
echo "             Enjoy!"
sleep 5
$CLS
f_BOOTMENU
}

f_ROMMENU () {
echo
echo
echo
echo
echo
echo
echo "So you want to flash a custom rom?"
echo "loading."
sleep 2
$CLS
echo "loading.."
sleep 1
$CLS
echo "loading..."
sleep 1
echo "Done loading"
echo
sleep 1
$CLS
echo
unset choice
echo "Menu:"
echo
echo "1) CyanogenMod"
echo "2) CarbonRom"
echo "3) Another rom"
echo "4) Quit"
echo
echo
echo -n "Your choice? : "
read choice
echo
echo
case $choice in
1) ROM=cm && f_ROMFLASH ;;
2) ROM=carbon && f_ROMFLASH ;;
3) f_REQUEST ;;
4) exit 0 ;;
*) echo "\"$choice\" is not valid"
sleep 2 ;;
esac
exit
}

f_ROMFLASH () {
echo
echo
echo
if (ROM=cm) ; then
	echo "go to https://download.cyanogenmod.org/?device=peregrine";
    echo "download the latest rom and move it to the Files/rom folder";
    echo "once there, rename the zip to cm.zip ";
fi
if (ROM=carbon); then
    echo "go to https://carbonrom.org/downloads/"
    echo "download the latest rom and move it to the Files/rom folder";
    echo "once there, rename the zip to carbon.zip ";
fi
echo "youll also need gapps, these can be found in the OP @ XDA"
echo "Rename the gappsXXX zip to gapps.zip"
echo "Press enter to continue"; read line
sleep 3
echo
$ADB "wait-for-device" reboot recovery
echo "Do you want to backup your phone? (recommended)"
echo "In order to do this, click backup and backup boot, data, and system."; read line
echo
sleep 5
echo "click advanced --> sideload"
echo "press enter to continue"; read line
echo "flashing"
sleep 1
$ADB "wait-for-device" sideload Files/rom/$ROM.zip
echo "click advanced --> sideload once again"
echo "press enter to continue"; read line
sleep 2
$ADB "wait-for-device" sideload Files/rom/gapps.zip
echo "Enjoy the experience. ;)"
echo "Remember, most roms are pre-rooted"
unset ROM
$ADB "wait-for-device" reboot recovery
f_BOOTMENU
}

f_REQUEST () {
echo
$CLS
echo "So you want to flash another rom?"
echo "Well, I am sorry to tell you that I do not support them."
echo "But you may request support if it is an official derivative of a rom."
echo "This is only for maintaining the quality of this toolkit."
echo "Who wants to be blamed for something they have no control over?"
echo "There is a way to flash those zips as a workaround though."
echo "Select CM and rename the zip you want to cm.zip"
echo "I do not support this and will laugh in your face if it does not work"
echo "you should really learn how to flash a rom manually."
sleep 15
$CLS
f_BOOTMENU
}

f_BOOTMENU () {
unset choice
unset ROM
echo "             Peregrine EasyRecovery $VERSION"
echo "             by somcom3x @ XDA"
echo
echo
echo
echo
echo
echo
sleep 5
$CLS
echo
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Please Read Carefully"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
echo
echo "Menu:"
echo
echo "1) Unlock the bootloader"
echo "2) This phone has its bootloader unlocked but no root/recovery"
echo "3) Just need root? (recovery required)"
echo "4) Tired of having an unlocked bootloader? Lock it here."
echo "5) Flash the stock motorola logo."
echo "6) Flash a custom rom."
echo "7) Quit"
echo
echo
echo -n "Your choice? : "
read choice
echo
echo
case $choice in
1) f_WARNING ;;
2) f_DEVICEMENU ;;
3) $ADB reboot recovery && sleep 21 && f_ROOT ;;
4) f_LOCK ;;
5) f_LOGO ;;
6) f_ROMMENU ;;
7) exit 0 ;;
*) echo "\"$choice\" is not valid"
sleep 2
esac
}

$CLS
echo
echo
echo
VERSION=
VERSION="v1.3.	1"
echo "               Easy Recovery for Peregine variants"
echo "               $VERSION "
echo "                         By somcom3x"
echo
echo "               Press enter to continue"
$CLS
echo
echo
echo
echo  "              You need to enable usb debugging first"
echo  "              Go to settings - applications - development"
echo
echo  "              Settings - About phone - Tap build number 7 times "
echo  "              Check developer settings"
echo
echo
echo "Press enter to continue"; read line
$CLS
cd $PWD
if [ -z $(which sudo 2>/dev/null) ]; then
	$ADB kill-server
else
	sudo $ADB kill-server
fi
if [ -z $(which sudo 2>/dev/null) ]; then
	$ADB start-server
else
	sudo $ADB start-server
fi
$CLS
MYDEVICE=`$ADB shell getprop ro.product.model`
rm -rf Files/Devices/*
echo
echo
echo
echo
echo
echo
echo
echo
echo "      		 	 Your device model is: $MYDEVICE"
echo
echo " 		 If this is incorrect please exit this program"
echo
echo
echo
echo
echo "Press enter to continue"; read line
$CLS
f_BOOTMENU
