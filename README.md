# CreatingMacISO
A short shell script to automate the process of creating an ISO file of any previous macOS for use with virutalization.

This script will create an iso file from most previous macOS installer files. Those ISOs can then be used to install macOS into most common VM apps like Virtualbox, VMware, or Parallels which struggle with DMG files. 

THE SCRIPT HAS ONLY ONE REQUIREMENT: that you've already downloaded a valid macOS installer file. If you haven't done that yet, just use the following links:

macOS 14.7 Sonoma - https://swcdn.apple.com/content/downloads/42/57/062-78824-A_60MNDAK5UB/dov1trqs34ol9r0b3zt3swgw04ndf7ctwm/InstallAssistant.pkg
macOS 13.7 Ventura - https://swcdn.apple.com/content/downloads/05/02/062-78643-A_T7YK72IEUB/f6jf452yv3xah9gljv28yxjs5x5bm7p1fr/InstallAssistant.pkg
macOS 12.7.6 Monterey - https://swcdn.apple.com/content/downloads/34/21/062-40406-A_GZQ27OUQER/ggclib72ow1omcvfexvp84bc9x5ei5tyqu/InstallAssistant.pkg
macOS 11.7.10 BigSur - http://swcdn.apple.com/content/downloads/14/38/042-45246-A_NLFOFLCJFZ/jk992zbv98sdzz3rgc7mrccjl3l22ruk1c/InstallAssistant.pkg
macOS 10.15 Catalina - https://itunes.apple.com/us/app/macos-catalina/id1466841314?ls=1&mt=12
macOS 10.14 Mojave - https://itunes.apple.com/us/app/macos-mojave/id1398502828?ls=1&mt=12
macOS 10.13 HighSierra - https://itunes.apple.com/us/app/macos-high-sierra/id1246284741?ls=1&mt=12
macOS 10.12 Sierra - http://updates-http.cdn-apple.com/2019/cert/061-39476-20191023-48f365f4-0015-4c41-9f44-39d3d2aca067/InstallOS.dmg

Once the installer has downloaded, it will auto-launch. Just QUIT the installer and then run this script with admin/sudo rights. It will automate making an iso file from any of the macOS installers listed above.

I'll update over time.
