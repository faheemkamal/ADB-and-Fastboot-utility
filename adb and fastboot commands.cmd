:: (C) Faheem Kamal 2016 (Team Revior)

:: Note - Change location in the below lines to point to your adb in your computer
cd /d %~dp0

@ECHO OFF

cls
ECHO WARNING!! If this utility stops responding for more than 1 minute, simply restart debugging by turning it off and on in developer options and start this utility again. This is due to incomplete logging permissions in the recent roms init file.

@ECHO ON

:: adb shell su mount -o rw,remount - /system

adb root

adb kill-server

adb start-server

:: adb remount


@ECHO OFF

:Begin
color 07
CLS
ECHO 1.See-connected-devices-in-ADB
:: ECHO 1.See-connected-devices-in-fastboot
ECHO 2.Start-continous-logging
ECHO 3.Dump-everything-at-once
ECHO 4.Dump-last-kmsg
ECHO 5.Reboot-Phone-from-OS
ECHO 6.Reboot-Phone-to-fastboot
ECHO 7.Reboot-Phone-to-recovery
ECHO 8.Flash-recovery-from-fastboot
ECHO 9.Fastboot-reboot-phone
:: ECHO e.Exit
ECHO.

CHOICE /C 123456789 /M "Enter your choice:"

:: Note - list ERRORLEVELS in decreasing order

:: IF ERRORLEVEL e GOTO Exit
IF ERRORLEVEL 9 GOTO Fastboot-reboot-phone
IF ERRORLEVEL 8 GOTO Flash-recovery-from-fastboot
IF ERRORLEVEL 7 GOTO Reboot-Phone-to-recovery
IF ERRORLEVEL 6 GOTO Reboot-Phone-to-fastboot
IF ERRORLEVEL 5 GOTO Reboot-Phone-from-OS
IF ERRORLEVEL 4 GOTO Dump-last-kmsg
IF ERRORLEVEL 3 GOTO Dump-everything-at-once
IF ERRORLEVEL 2 GOTO Start-continous-logging
:: IF ERRORLEVEL 1 GOTO See-connected-devices-in-fastboot
IF ERRORLEVEL 1 GOTO See-connected-devices-in-ADB

:Exit
ECHO Exit 
GOTO End

:Dump-last-kmsg
ECHO Dump last kmsg
adb shell cat /proc/last_kmsg > logs-dump-last_kmsg.txt
GOTO Begin

:Dump-everything-at-once
ECHO Dump everything at once 
adb shell dmesg > logs-dump-dmsg.txt
adb logcat -b radio -v time -d > logs-dump-logcat_radio.log
adb logcat -v time -d > logs-dump-logcat.log
:: adb shell su dmesg | grep 'avc: ' >  logs-denials-sepolicy.txt
GOTO Begin

:Start-continous-logging
ECHO Start-continous-logging
start cmd.exe /c "adb logcat -v time > logs-continuous-logcat.log"
start cmd.exe /c "adb logcat -b radio -v time > logs-continuous-logcat_radio.log"
start cmd.exe /c "adb shell cat /proc/kmsg > logs-continuous-kmsg.txt"
cls
ECHO ATTENTION!! DO NOT CLOSE THE 3 WINDOWS ! They are required for the continuous logging.
@pause

GOTO Begin

:Reboot-Phone-from-OS
ECHO Reboot-Phone-from-OS
adb reboot
GOTO Begin

:Flash-recovery-from-fastboot
ECHO Flash-recovery-from-fastboot
ECHO Instructions: Please put the recovery file in the adb folder and rename it to recovery.img
@pause
fastboot flash recovery recovery.img
GOTO Begin

:Fastboot-reboot-phone
ECHO Fastboot-reboot-phone
fastboot reboot
GOTO Begin

:Reboot-Phone-to-fastboot
ECHO Reboot-Phone-to-fastboot
adb reboot-bootloader
GOTO Begin

:Reboot-Phone-to-recovery
ECHO Reboot-Phone-to-recovery
adb reboot recovery
GOTO Begin

:See-connected-devices-in-ADB
ECHO Reboot-Phone-to-recovery
adb devices
@pause
GOTO Begin

:See-connected-devices-in-fastboot
ECHO Reboot-Phone-to-recovery
fastboot devices
@pause
GOTO Begin

:End
