#!/bin/sh
# add -xv to the end of the previous line to debug

# This script will create a bootable macOS iso that can be used to install macOS
# into most common VM apps like Virtualbox, VMware, or Parallels

# SCRIPT HAS ONLY ONE REQUIREMENT:
# You must already have downloaded a valid macOS installer file.
# If you haven't, use the following links:

# Catalina: https://itunes.apple.com/us/app/macos-catalina/id1466841314?ls=1&mt=12
# Mojave: https://itunes.apple.com/us/app/macos-mojave/id1398502828?ls=1&mt=12
# High Sierra: https://itunes.apple.com/us/app/macos-high-sierra/id1246284741?ls=1&mt=12
# Sierra: http://updates-http.cdn-apple.com/2019/cert/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg

# Once the installer has downloaded, it will auto-launch. QUIT the installer and run this script with admin/sudo rights.

# Last Update: 3/12/20

# ---------------------------------------------------------
#   Set all Variables
# ---------------------------------------------------------

#----- Debugging 
# bash -x ./[script_name.sh] 		#for detailed script output
# bash -n ./[script_name.sh]		#for syntax checking
set -u   # verbose error checking during execution

#----- Executables
mkdir=`which mkdir`
chown=`which chown`
chmod=`which chmod`
hdiutil=`which hdiutil`
mv=`which mv`
rm=`which rm`
date=`which date`
echolog=`which echolog`

#----- Standards
script=$"Creating macOS iso"
now=$(date +"%m-%d-%Y %H:%M:%S %z")
Result=$?

#----- Logging
Log="/Library/Logs/CreatingMacOSisoFile"
# if [ ! -d "${Log}" ];
# then
# 	$mkdir $Log
# 	$chown root:wheel $Log
# 	$chmod 777 $Log
# fi

#----- Functions
echolog()		#Helps to direct certain output to the screen, others to our log file
(
echo $1
echo $1 >> $Log
)
# Thank you Andru Witta: https://unix.stackexchange.com/questions/80707/how-to-output-text-to-both-screen-and-file-inside-a-shell-script

#----------------------------------------------------------
#  Timestamp
#----------------------------------------------------------
echolog ""
echolog "##### $script"
echolog "##### $now"

#----------------------------------------------------------
#  Script
#----------------------------------------------------------

echolog "Which version of the macOS installer would you like to convert to an iso?"
PS3='Type a number & press enter: '
options=("Catalina" "Mojave" "High Sierra" "Sierra" "Quit")
select choice in "${options[@]}"
do
    case "${choice}" in
        "Catalina")
            echolog "You've chosen macOS $choice" && break
            ;;
        "Mojave")
            echolog "You've chosen macOS $choice" && break
            ;;
        "High Sierra")
            echolog "You've chosen macOS $choice" && break
            ;;
        "Sierra")
            echolog "You've chosen macOS $choice" && break
            ;;
        "Quit")
            echolog "You've chosen to quit this script. Byeeeeee." && exit 0
            ;;
        *) echolog "Please enter a valid option.";;
    esac
done

echolog "" & echolog "Now, we'll create a 'virtual USB flash drive' disk image..."
sudo hdiutil create -o /tmp/"${choice}" -size 8G -layout SPUD -fs HFS+J -type SPARSE

echolog "" & echolog "Now we'll mount the temp drive we just created...:"
sudo hdiutil attach /tmp/"${choice}".sparseimage -noverify -mountpoint /Volumes/install_build

echolog "" & echolog "Now we'll write the installer files into our mounted disk image..."
if [ "${choice}" = "Sierra" ]; then
	sudo /Applications/Install\ macOS\ "${choice}".app/Contents/Resources/createinstallmedia --volume /Volumes/install_build --applicationpath "/Applications/Install macOS "${choice}".app"
else
	sudo /Applications/Install\ macOS\ "${choice}".app/Contents/Resources/createinstallmedia --volume /Volumes/install_build
fi

echolog "" & echolog "Unmounting the disk image, so that the resource will not be busy for the next step..."
hdiutil detach /Volumes/Install*

echolog "" & echolog "Converting the disk image into an ISO file since VirtualBox is not capable of booting from a .dmg or .sparseimage file..."
hdiutil convert /tmp/"${choice}".sparseimage -format UDTO -o /tmp/"${choice}".iso

echolog "" & echolog "Moving our .iso file to the desktop and renaming it..."
mv /tmp/"${choice}".iso.cdr ~/Desktop/"${choice}".iso

echolog "" & echolog "Removing the sparseimage file from the tmp folder..."
rm /tmp/"${choice}".sparseimage
 
echolog "" & echolog "Your macOS iso is now available on your desktop."

exit 0