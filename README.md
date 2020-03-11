# CreatingMacISO
A short shell script to automate the process of creating an ISO file of any previous macOS for use with virutalization.

This script will create an iso file from most previous macOS installer files. Those ISOs can then be used to install macOS into most common VM apps like Virtualbox, VMware, or Parallels which struggle with DMG files. 

THE SCRIPT HAS ONLY ONE REQUIREMENT: that you've already downloaded a valid macOS installer file. If you haven't done that yet, just use the following links:

Catalina: https://itunes.apple.com/us/app/macos-catalina/id1466841314?ls=1&mt=12
Mojave: https://itunes.apple.com/us/app/macos-mojave/id1398502828?ls=1&mt=12
High Sierra: https://itunes.apple.com/us/app/macos-high-sierra/id1246284741?ls=1&mt=12
Sierra: http://updates-http.cdn-apple.com/2019/cert/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg

Once the installer has downloaded, it will auto-launch. Just QUIT the installer and then run this script with admin/sudo rights. It will automate making an iso file from any of the macOS installers listed above.

I'll update over time.
