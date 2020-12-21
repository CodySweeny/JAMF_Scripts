#!/bin/bash

AU=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall)

if [ $AU = 0 ]; then
	echo "<result>Off</result>"
else
	echo "<result>On</result>"
fi
