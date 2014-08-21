@echo off
@echo off
cls
color 0A
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                 Easy Recovery for Peregine variants
echo.
echo                           By somcom3x
echo.
echo.
echo.
echo.
pause
cls
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                   You need to enable usb debugging
echo              Go to settings - applications - development
echo.
echo                         Or in ICS and higher
echo            Settings - Developer Options - Android Debugging
echo.
echo                         Or in 4.2 and higher
echo  Settings - About phone - Tap build number 7 times - Use ICS instructions
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
echo.
echo.
echo.
echo.
echo.
echo                      Your device is: %MYDEVICE%
echo.
echo           If this is incorrect please exit this program
echo.
echo.
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
echo 5) Quit
echo.
echo.
set menu=""
set /p menu=Please type a number [1-4] and press enter 
echo.
echo.
if "%menu%"=="1" goto :WARNING
if "%menu%"=="2" goto :DEVICEMENU
if "%menu%"=="3" %AdbExe% reboot recovery && ping 127.0.0.1 -n 22 -w 1000 > nul && goto :ROOT
if "%menu%"=="4" goto :LOCK
if "%menu%"=="5" goto :eof
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
echo   Warning
echo   Warning
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
$FASTBOOT oem get_unlock_data
echo enter this code on page 2 as shown in the example:
echo enter code on the website and press enter
pause
echo enter the key emailed to you here:
set KEY=""
set /p KEY=Please paste the number emailed here: 
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
echo.
echo.
echo.
echo                   You need to enable usb debugging again
echo.
echo                Go to settings - applications - development
echo.
echo                          Or in ICS and higher
echo             Settings - Developer Options - Android Debugging
echo.
echo                         Or in 4.2 and higher
echo  Settings - About phone - Tap build number 7 times - Use ICS instructions
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
echo                  EasyRecovery v1.0
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
if "%menu%"=="3" goto :eof
goto :FLASH

:FLASH
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
