#!/bin/bash
# add -xv to the end of the previous line to debug

# This script will create a bootable macOS iso that can be used to install macOS
# into most common VM apps like Virtualbox, VMware, or Parallels

# SCRIPT HAS ONLY ONE REQUIREMENT:
# You must already have downloaded and installed a valid macOS installer file.
# If you haven't, use the readme.md in the main branch: https://github.com/tallfunnyjew/CreatingMacISO/blob/master/README.md
# or visit https://osxdaily.com/where-download-macos-installers/

# Once the installer has downloaded, it will auto-launch. QUIT the installer and -> run this script with admin/sudo rights. <-

# Thanks to Andru Witta for printing log to screen and file: https://unix.stackexchange.com/questions/80707/how-to-output-text-to-both-screen-and-file-inside-a-shell-script

# Updates:
	# 10/15/24 - syntax, grammar, updated code
	# 10/23/24 - preflight checks for disk space and installers being present

# ---------------------------------------------------------
#   Set all Variables
# ---------------------------------------------------------

#----- Debugging 
# bash -x ./[script_name.sh] 		#for detailed script output
# bash -n ./[script_name.sh]		#for syntax checking
# set -u   # verbose error checking during execution

#----- Executables
chown=$(which chown)
chmod=$(which chmod)
touch=$(which touch)
hdiutil=$(which hdiutil)
mv=$(which mv)
rm=$(which rm)
date=$(which date)
echo=$(which echo)
check=$(perl -e 'print "\xE2\x9C\x94"')

#----- Standards
script="Creating a macOS.iso"
date=$(date -R)

#----- Tests
driveID=$(diskutil list | grep Data | awk ' {print $10} ')
spaceRAW=$(diskutil info "$driveID" | grep Free | awk ' { print $4 } ')
spaceINT=${spaceRAW%.*}
appPRESENT=$(ls -la /Applications | grep "Install macOS")

#----- Logging
Log="/Library/Logs/CreatingMacOSisoFile.log"
if [ ! -f "${Log}" ];
then
	$touch $Log
	$chown root:wheel $Log
	$chmod 777 $Log
fi

#----- Functions
echolog() {
echo "$1"
echo "$1" >> $Log
}

testForSpace() {
if [ "$spaceINT" -lt 30 ]; then
	echolog "You need at least 30GB of free space on your internal HD." && echolog "Now exiting."
	exit 1
else
	echolog "You have at least than 30GB of free space on your HD. $check Continuing..."
fi
}

macOSPresent() {
if [ -z "$appPRESENT" ]; then
	echolog "You DON'T have a macOS Installer in your Applications folder." && echolog "Now exiting."
	exit 1
else
	echolog "You have at least one macOS Installer present. $check Continuing..."
fi
}

#----- Arrays
macOS=( "Sonoma" "Ventura" "Monterey" "Big Sur" "Catalina" "Mojave" "High Sierra" "Sierra" "Quit" )

#----------------------------------------------------------
#  Timestamp
#----------------------------------------------------------
echolog ""
echolog "##### $script"
echolog "##### $date"
echolog ""


#----------------------------------------------------------
#  Script
#----------------------------------------------------------

echolog "Running pre-flight tests for available space and macOS installers:"
testForSpace
macOSPresent


echolog "Enter the number of the macOS installer you'd like to convert to an iso:"
echolog ""

# PS3='Type a number & press enter: '
options=("Sonoma" "Ventura" "Monterey" "Big Sur" "Catalina" "Mojave" "High Sierra" "Sierra" "Quit")
select choice in "${options[@]}"
	do
		case "${choice}" in
			"Sonoma")
				echolog "You've chosen macOS $choice." && break ;;
			"Ventura")
				echolog "You've chosen macOS $choice." && break ;;
			"Monterey")
				echolog "You've chosen macOS $choice." && break ;;
			"Big Sur")
				echolog "You've chosen macOS $choice." && break ;;
			"Catalina")
				echolog "You've chosen macOS $choice." && break ;;
			"Mojave")
				echolog "You've chosen macOS $choice." && break ;;
			"High Sierra")
				echolog "You've chosen macOS $choice." && break ;;
			"Sierra")
				echolog "You've chosen macOS $choice." && break ;;
			"Quit")
				echolog "Quitting script. See you soon...?" && exit 0
				;;
			*) echolog "Please enter a valid option.";;
		esac
	done

if [ ! -d /Applications/Install\ macOS\ "${choice}".app ];
then
    echolog "This script cannot run until you first download & install the macOS ${choice} application into your Applications folder. Do that, then re-run this script."
	exit 0
else
	echolog "Creating a 'virtual USB flash drive' disk image..."
	sudo hdiutil create -o /tmp/"${choice}" -size 15G -layout SPUD -fs HFS+J -type SPARSE
	
	echolog "Mounting the temp drive we just created...:"
	sudo hdiutil attach /tmp/"${choice}".sparseimage -noverify -mountpoint /Volumes/install_build
	
	echolog "Writing the installer files into our mounted disk image..."
	if [ "${choice}" = "Sierra" ]; then
		sudo /Applications/Install\ macOS\ "${choice}".app/Contents/Resources/createinstallmedia --volume /Volumes/install_build --applicationpath "/Applications/Install macOS ""${choice}"".app"
	else
		sudo /Applications/Install\ macOS\ "${choice}".app/Contents/Resources/createinstallmedia --volume /Volumes/install_build  <<end
Y
end
	fi
	
	echolog "" && echolog "Unmounting the disk image, so that the resource will not be busy for the next step..."
	hdiutil detach /Volumes/Install*
	
	echolog "Converting the disk image into an ISO file since VirtualBox is not capable of booting from a .dmg or .sparseimage file..."
	hdiutil convert /tmp/"${choice}".sparseimage -format UDTO -o /tmp/"${choice}".iso
	
	echolog "Moving our .iso file to the desktop and renaming it..."
	mv /tmp/"${choice}".iso.cdr ~/Desktop/"${choice}".iso
	
	echolog "Removing the sparseimage file from the tmp folder..."
	rm /tmp/"${choice}".sparseimage
	 
	echolog "Your macOS $choice iso is now on your desktop. Happy VM-ing!"
fi

exit 0
