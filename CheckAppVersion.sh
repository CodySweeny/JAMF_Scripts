#!/bin/sh

#Check to see if Zoom client is installed and if true, what is the version

if [ -d /Applications/Mount\ Home\ Folder.app ]; then
MountFSVersion=$(sudo defaults read /Applications/Mount\ Home\ Folder.app/Contents/info.plist CFBundleShortVersionString)
echo "<result>$MountFSVersion</result>"
else
echo "<result>Not installed</result>"
fi