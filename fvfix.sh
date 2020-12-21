#/bin/bash
#Cody Sweeny
#9/9/2020
#Refreshes recovery key so that jamf can escrow it.
#Adds jamfcloud_mac as an approved filevault user and removes hvadmin48 and hvadmin481 from the clients computer.
OldAdmin=""
OldAdminPass=""
TempAcc=$(dscl . list /Users | grep "$OldAdmin" )
#FVOldAdminCheck=$(fdesetup list | grep "$OldAdmin" | sed -e 's/^\(.\{9\}\).*\(.\{0\}\)$/\1 \2/')
FVAdminCheck=$(fdesetup list $OldAdmin -password $OldAdminPass | grep "$Admin" | sed -e 's/^\(.\{13\}\).*\(.\{0\}\)$/\1 \2/')


#Add JamfCloud_Mac
sudo fdesetup add -inputplist < /var/tmp/fdesetup.plist

#Change Recovery Key
sudo fdesetup changerecovery -personal -inputplist < /var/tmp/ChangeKey.plist

#Escrow the key
sudo jamf recon
echo "Key was successfully escrowed"

#SecureTokenCheck
if [ $Admin = $FVAdminCheck ]; then
   sudo jamf policy -trigger OldAdminRemoval
   echo "$OldAdmin was removed"
  else
  	   exit 1
  	   echo "$Admin was not enabled in FileVault"
  	   ech "$OldAdmin is still enabled in FileVault"
fi
#Remove Old Admin from Computer
if [ $TempAcc =  ]; then
   sudo jamf policy -trigger hvadmin481Removal
  else
  	   echo "OldAdmin was not found"
fi

#Remove Jamf Log
sudo rm -f /var/log/jamf.log
#Remove the plist
sudo rm -f /var/tmp/fdesetup.plist
sudo rm -f /var/tmp/UserAuth.plist

#Clean up
echo "Yay! It worked!"
exit 0
