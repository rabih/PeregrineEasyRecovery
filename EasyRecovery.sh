#!/bin/sh
# Unix OS Sniffer and $adb setup by Firon
platform=`uname`;
ADB=$PWD"/Files/tools/adb";
FASTBOOT=$PWD"/Files/tools/fastboot";
cd "$(dirname "$0")"
if [ -z $(which adb) ]; then
	ADB=$PWD"/Files/tools/adb";
    FASTBOOT=$PWD"/Files/tools/fastboot";
	if [ "$platform" == 'Darwin' ]; then
		ADB=$PWD"/Files/tools/adb.osx"
		FASTBOOT=$PWD"/Files/tools/fastboot.osx"
	fi
fi
chmod +x $ADB
chmod +x $FASTBOOT
CLS='printf "\033c"'
# End section, thanks Firon!

f_ROOT () {
$CLS
sleep 3
echo "Pushing Recovery Script"
$ADB push Files/root/supersu.zip /storage/sdcard0/supersu.zip
$ADB push Files/root/command /cache/recovery/command
$ADB shell killall recovery
sleep 3
echo "Running automated recovery commands"
sleep 4
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
echo "         All in One Root and Recovery v1.0"
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
echo "  Warning"
echo "  Warning"
echo "  Warning"
echo "  Warning"
echo "   THIS WILL WIPE ALL OF YOUR APPS, CONTACTS GAMESAVES ETC EVERYTHING"
echo "                      INCLUDING YOUR SD CARD"
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
f_EMPTY
f_UNLOCK
f_BOOTMENU
}

f_EMPTY () {
echo
}

f_BOOTMENU () {
unset choice
while :
do
echo 
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Please Read Carefully"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo 
echo 
echo "Menu:"
echo 
echo "1) This is a stock bootloader locked phone"
echo "2) This phone has its bootloader unlocked but no root/recovery"
echo "3) Just need root? (recovery required)"
echo "4) Tired of having an unlocked bootloader? Lock it here."
echo "5) Quit"
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
5) exit 0 ;;
*) echo "\"$choice\" is not valid"
sleep 2 ;;
esac
done
}


$CLS
echo 
echo 
echo 
echo 
echo 
echo 
echo 
echo 
echo "                     One Click Root and Recovery"
echo 
echo "              	   By Somcom3x @ XDA Developers"
echo
echo "                     Big Credits to ShabbyPenguin"
echo 
echo 
echo "Press enter to continue"; read line
$CLS
echo 
echo 
echo 
echo 
echo 
echo 
echo 
echo 
echo "                    You need to enable usb debugging first"
echo 
echo "                  Go to settings - applications - development"
echo 
echo
echo "                         Or in ICS and higher"
echo "             Settings - Developer Options - Android Debugging"
echo
echo  "                       Or in 4.2 and higher"
echo  "Settings - About phone - Tap build number 7 times - Use ICS instructions"
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
