#!/bin/sh

#Find Current User
CurrentUser=`/usr/bin/who | awk '/console/{ print $1 }'`

#Set Command Variable for trusted application
register_trusted_cmd="/usr/bin/sudo -u $CurrentUser /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted"

#Set Variable for application being run against
application="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app"

#This runs the combination of variables above that will block the running
#of the autoupdate.app until the user actually clicks on it, or goes
#into the help check for updates menu.  Additionally this needs to be
#run for each user on a machine.
$register_trusted_cmd "$application"

#Ungracefully removes Office 2011
/bin/rm -rf /Applications/Microsoft\ Office\ 2011/

#Turns off the FirstRunScreen for each application.
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.PowerPoint kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Excel kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Word kSubUIAppCompletedFirstRunSetup1507 -bool true

# Reads user input (username and barcode)
echo "Enter Computer Number (last 4 Digits) > "
read barcode
echo "You entered: $barcode"
echo "Enter username >"
read un
echo "You entered: $un"
echo "Enter computer type (MBA15/MBPr15/MBP13)"
read type_1
echo "You entered: $type_1"

# Creates computer name
compname="$type_1-$barcode-$un"
echo "computers name is $compname"

# Changes computer name in sharing preferences
scutil --set ComputerName $compname
scutil --set HostName $compname
scutil --set LocalHostName $compname

# Changes user's full name and account name (username)
# does _not_ change the users home folder
dscl . -change /Users/$CurrentUser RealName $CurrentUser $un
dscl . -change /Users/$CurrentUser RecordName $CurrentUser $un

exit 0
