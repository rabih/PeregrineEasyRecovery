@echo off
@echo off
cls
color 0A
echo.
set Version=
set Version=v1.3.2
echo.
echo                 Easy Recovery for Peregine variants
echo                 %Version%
echo                           By somcom3x
echo.
echo.
pause
cls
echo.
echo.
echo.
echo.
echo  You need to enable usb debugging.
echo  On 4.4:
echo  Settings - About phone - Tap build number 7 times - back key
echo  Developer options - Android debugging
echo.
echo.
color 0A
ping -n 2 127.0.0.1 > nul
color 0C
ping -n 2 127.0.0.1 > nul
color 0A
echo.
echo.
echo.
echo.
pause
cls
@rem *** Find AD.EXE or abort *********************************************
set BatchFileDir=%~dp0
set AdbExe=%BatchFileDir%/Files/tools/adb.exe
if exist "%AdbExe%" goto FoundAdbExe
set AdbExe=%CD%\/Files/tools/adb.exe
if exist "%AdbExe%" goto FoundAdbExe
set AdbExe=
for %%f in ("AdbExe") do set AdbExe=%%~$PATH:f
if not "%AdbExe%" == "" FoundAdbExe
echo ERROR: Could not find "adb.exe" (have you installed it?)
echo.
echo To find ADB.EXE this script:
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo (1) Looks in the same directory as the batch file ("%BatchFileDir%)
echo.
echo (2) Looks in the current directory (%CD%)
echo.
echo (3) Looks in the PATH, that is one of the following directories: %PATH%
echo.
pause
goto :EOF
:FoundAdbExe
echo.
echo USING ADB: "%AdbExe%"
echo.
@rem *** Find Fastboot.EXE or abort *********************************************
set BatchFileDir=%~dp0
set Fastboot=%BatchFileDir%/Files/tools/fastboot.exe
if exist "%Fastboot%" goto FoundFastboot
set Fastboot=%CD%\/Files/tools/fastboot.exe
if exist "%Fastboot%" goto FoundFastboot
set Fastboot=
for %%f in ("Fastboot") do set Fastboot=%%~$PATH:f
if not "%Fastboot%" == "" FoundFastboot
echo ERROR: Could not find "Fastboot.EXE" (have you installed it?)
echo.
echo To find Fastboot.EXE this script:
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo (1) Looks in the same directory as the batch file ("%BatchFileDir%)
echo.
echo (2) Looks in the current directory (%CD%)
echo.
echo (3) Looks in the PATH, that is one of the following directories: %PATH%
echo.
pause
goto :EOF
:FoundFastboot
cls
@rem *** Find mFastboot.EXE or abort *********************************************
set BatchFileDir=%~dp0
set mFastboot=%BatchFileDir%/Files/tools/mfastboot.exe
if exist "%mFastboot%" goto FoundmFastboot
set Fastboot=%CD%\/Files/tools/mfastboot.exe
if exist "%mFastboot%" goto FoundmFastboot
set mFastboot=
for %%f in ("mFastboot") do set mFastboot=%%~$PATH:f
if not "%mFastboot%" == "" FoundmFastboot
echo ERROR: Could not find "mFastboot.EXE" (have you installed it?)
echo.
echo To find mFastboot.EXE required for this script:
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo (1) Look in the same directory as the batch file ("%BatchFileDir%)
echo.
echo (2) Look in the current directory (%CD%)
echo.
echo (3) Look in the PATH, that is one of the following directories: %PATH%
echo.
pause
goto :EOF
:FoundmFastboot
cls
echo USING FASTBOOT: "%Fastboot%"
echo.
echo.
echo.
echo.
pause
cls
cd "%~dp0"
%AdbExe% kill-server 2>NUL
SET MYDEVICE=
SET RECOVERY=
%AdbExe% start-server 2>NUL
cls
del mydevicetmp 2>NUL
%AdbExe% shell getprop ro.product.model > mydevicetmp
set /p MYDEVICE= < mydevicetmp
del mydevicetmp 2>NUL
cls
echo.
echo.
echo.
echo                      Your device is: %MYDEVICE%
echo.
echo           If this is incorrect please exit this program
echo.
echo.
pause
cls
goto :BOOTMENU

:BOOTMENU
echo.
echo +++///+++///+++///+++///+++///+++///+++///+++///+++++
echo Please Read Carefully
echo ///+++///+++///+++///+++///+++///+++///+++///+++///++
echo.
echo.
echo Menu:
echo.
echo 1) Unlock the bootloader
echo 2) This phone has its bootloader unlocked but no root/recovery
echo 3) Just need root? (recovery required)
echo 4) Tired of having an unlocked bootloader? Lock it here.
echo 5) Flash the stock boot logo to remove the contract at boot.
echo 6) Quit
echo.
echo.
set menu=""
set /p menu=Please type a number [1-6] and press enter 
echo.
echo.
if "%menu%"=="1" goto :WARNING
if "%menu%"=="2" goto :DEVICEMENU
if "%menu%"=="3" %AdbExe% reboot recovery && ping 127.0.0.1 -n 22 -w 1000 > nul && goto :ROOT
if "%menu%"=="4" goto :LOCK
if "%menu%"=="5" goto :LOGO
if "%menu%"=="6" goto :eof
goto :bootmenu

REM This is the part of the script that unlocks the bootloader and then forwards onto menu so users can pick their device

:WARNING
cls
echo.
echo +++///+++///+++///+++///+++///+++///+++///+++///+++///
echo Please Read Carefully
echo ///+++///+++///+++///+++///+++///+++///+++//////+++///

ping -n 4 127.0.0.1 > nul
cls
color C0
echo   Warning
echo   Warning
echo    THIS WILL WIPE ALL OF YOUR APPS, CONTACTS GAMESAVES ETC EVERYTHING
echo                        on YOUR _internal_ SDCARD
echo   Warning
echo   Warning
ping -n 2 127.0.0.1 > nul
color 0C
ping -n 2 127.0.0.1 > nul
color C0
ping -n 2 127.0.0.1 > nul
color 0A
ping -n 2 127.0.0.1 > nul
color 0C
echo.
echo.
echo.
echo Do you wish to continue?
echo.
echo.
set menu=""
set /p menu=Please type Y/N and press enter 
echo.
echo.
cls
color 0A
if "%menu%"=="y" goto :UNLOCK
if "%menu%"=="Y" goto :UNLOCK
if "%menu%"=="N" goto :eof
if "%menu%"=="n" goto :eof
goto :WARNING

:UNLOCK
%AdbExe% wait-for-device reboot bootloader
@ping 127.0.0.1 -n 6 -w 1000 > nul
cls
echo if your phone is not displayed or it stays on waiting for device for too long then there was an error with the drivers or its not in fastboot
echo.
%Fastboot% devices
echo.
echo Please look at your phone and see its in the fastboot menu
echo.
echo.
echo.
echo.
echo go to http://bit.ly/UpVtsa and read the risks, continue to page 2
pause
echo are you sure???? Do you know the risks? Are you willing to do this??? pause
%Fastboot% oem get_unlock_data
echo enter this code on page 2 as shown in the example:
echo enter code on the website and press enter
pause
echo enter the key emailed to you here:
set key=""
set /p key=Please paste the number emailed here:
%Fastboot% oem unlock %key%
echo FASTBOOT oem unlock %key%
echo .
echo Press enter to continue
pause
echo.
%Fastboot% oem unlock
echo.
pause
echo.
echo.
%Fastboot% reboot
cls
%AdbExe% wait-for-device devices
cls
echo.
echo.
echo.
echo.
echo.
echo  You need to enable usb debugging again.
echo  On 4.4:
echo  Settings - About phone - Tap build number 7 times - back key
echo  Developer options - Android debugging
echo.
color 0A
ping -n 2 127.0.0.1 > nul
color 0C
ping -n 2 127.0.0.1 > nul
color 0A
echo.
echo.
echo.
echo.
pause
goto :DEVICEMENU

:LOCK
cls
echo
echo
echo So the custom life isn't for you? Press enter to continue.
pause
echo Last chance to stick around.
pause
%AdbExe% reboot bootloader
pause
echo  when you see the fastboot screen press enter to continue.
%Fastboot% oem lock
echo Locking...
pause
echo Your bootloader is now locked.
pause
echo
echo
echo
goto :BOOTMENU

:DEVICEMENU
cls
echo.
echo                  EasyRecovery %Version%
echo.
echo.
echo.
echo Menu:
echo.
echo 1) Root and Install ClockworkMod
echo 2) Root and Install OUDHS Recovery
echo 3) No root or recovery desired. (quit)
echo.
echo.
set menu=""
set /p menu=Please type a number [1-3] and press enter 
echo.
echo.
if "%menu%"=="1" set RECOVERY=CWM
if "%menu%"=="2" set RECOVERY=TWRP
if "%menu%"=="3" goto :EOF
goto :FLASH

:FLASH
cls
echo are you sure you want to do this? Are you really?
pause
echo Last chance, press enter to continue
pause
%AdbExe% reboot bootloader
cls
echo.
echo.
echo.
echo        Grabbing %RECOVERY%..
%Fastboot% flash recovery Files/recovery/%RECOVERY%.img
cls
echo.
echo.
echo please use the volume down button and select recovery and press volume up
echo.
echo.
pause
goto :ROOT

:ROOT
cls
echo.
echo.
echo.
echo.
echo Pushing Recovery Script
echo.
%AdbExe% push Files/root/superuser.zip /storage/sdcard0/supersu.zip
%AdbExe% push Files/root/command /cache/recovery/command
%AdbExe% shell killall recovery
echo.
echo Running automated recovery commands
echo.
@ping 127.0.0.1 -n 3 -w 1000 > nul
echo Choose yes and enjoy root :)
pause
%AbdExe% reboot
goto :BOOTMENU

:LOGO
echo.
echo.
echo So you want to get rid of the contract on bootup?
echo.
set logo=""
set /p logo=Continue? Y or N?
echo.
echo.
if "%cont%"=="Y" goto :LOGO2
if "%cont%"=="y" goto :LOGO2
if "%cont%"=="N" goto :EOF
if "%cont%"=="n" goto :EOF

:LOGO2
cls
echo.
echo when your device is in the bootloader screen, press enter.
%AbdExe% reboot bootloader
pause
echo.
%Fastboot% flash logo Files/logo/peregrine_logo_mod.bin
echo.
echo.
echo              Enjoy!
pause
echo            Press enter to continue
goto :BOOTMENU

:ROMMENU
cls
echo.
echo.
echo.
echo.
echo.
echo            So you want to flash a rom?
echo            Easy task if I say so myself.
echo            Choose one of the following:
echo      1) CyanogenMod
echo      2) CarbonRom
echo      3) Other
echo      4) Exit
set romS=""
set /p romS=Choose a number between 1-4
echo.
echo.
if "%romS%"=="1" set rom=%CD%\/Files/rom/cm.exe && set roms=cyanogenmod && goto :ROMFLASH
if "%romS%"=="2" set rom=%CD%\/Files/rom/carbon.exe && set roms=carbon && goto :ROMFLASH
if "%romS%"=="3" goto :UNSUP
if "%romS%"=="4" goto :EOF

:ROMFLASH
cls
echo.
echo.
echo.
echo.
if roms=carbon then
    echo go to https://carbonrom.org/downloads/
    echo download the latest rom and move it to the Files/rom folder
    echo once there, rename the zip to carbon.zip
if roms=cyanogenmod then
	echo go to https://download.cyanogenmod.org/?device=peregrine
    echo download the latest rom and move it to the Files/rom folder
    echo once there, rename the zip to cm.zip
echo press enter to continue
pause
cls
echo you'll also need gapps, these can be found in the OP @ XDA
echo Rename the gappsXXX zip to gapps.zip and move to Files/rom folder
echo Press enter to continue
pause
cls
echo Do you want to make a backup first? (recommended)
echo In order to make a backup, you must select backup -> and backup
echo Boot, Data, and System.
%AdbExe% reboot recovery
echo.
echo Navigate to advanced/sideload and move the bottom slider (twrp)
echo or install/sideload (cwm)
echo press enter on your computer twice to continue
pause
pause
echo.
echo.
%AdbExe% sideload %rom%
echo press enter when in recovery and navigate to advanced/sideload (twrp)
echo or install/sideload (cwm) once again.
%AdbExe% sideload Files/rom/gapps.zip
%AdbExe% reboot

:REQUEST
echo .
CLS
echo So you want to flash another rom?
echo Well, i'm sorry to tell you that I don't support them.
echo But you may request support if it is an official derivative of a rom.
echo This is only for maintaining the quality of this toolkit.
echo Who want's to be blamed for something they have no control over?
echo There is a way to flash those zips as a workaround though.
echo Select CM and rename the zip you want to cm.zip
echo I don't support this and will laugh in your face if it does not boot.
echo you should really learn how to flash a rom manually.
sleep 15
$CLS
