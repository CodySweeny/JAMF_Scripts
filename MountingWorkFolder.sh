#!/bin/bash

# SMB location here
serverShare="SHAREGOESHERE/users/${loggedInUser}"
ServerSecondary="SECONDARYSHARE/Regional Marketing"

# Mount the drive as john_doe while logged in as john_doe
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
path="smb://${loggedInUser}:@${serverShare}/${loggedInUser}"
path2="smb://${loggedInUser}:@${ServerSecondary}"
/usr/bin/osascript -e "mount volume \"$path\""
/usr/bin/osascript -e "mount volume \"$path2\""



exit 0