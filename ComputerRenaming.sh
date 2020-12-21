#/bin/bash
#Cody Sweeny
#7/15/2020
#Renames computer to iMAC,MBP or MBA, Department and Last 5 of MacAddress (MBP-DEP-XXXX)
#serial=$(ioreg -l IOPlatformSerialNumber | sed -En 's/^.*"IOPlatformSerialNumber".*(.{4})"$/\1/p')

#!/bin/bash
## account with computer create and read (JSS Objects), Send Computer Unmanage Command (JSS Actions)
#!/bin/sh

## API details with computer read privs
apiUser=""
apiPass=""
server=""
## Get the computer's name
compName=$(scutil --get ComputerName)
serial=$(ioreg -l IOPlatformSerialNumber | sed -En 's/^.*"IOPlatformSerialNumber".*(.{12})"$/\1/p')

## Possible strings to use below:
##  "username"
##  "real_name"
##  "email_address"
##  "position"
##  "phone"
##  "department"
##  "building"
##  "room"

section="department"

Department=$(curl -H "Accept: text/xml" -sfku "${apiUser}:${apiPass}" "${server}/JSSResource/computers/macaddress/$(networksetup -getmacaddress en0 | awk '{print $3}')/subset/location" | xmllint --format - 2>/dev/null | grep "<${section}" | awk -F'>|<' '{print $3}' | cut -c 1-3 | tr '[:lower:]' '[:upper:]')
serial=$(ifconfig en0 | grep -Eo ..\(\:..\){5} | sed 's/[[:punct:]]//g' | sed -n 's/\(^.[^$]*\)\(.\{5\}$\)/\2/p' | tr '[:lower:]' '[:upper:]')
model=$(ioreg -l | grep "product-name" | cut -d "=" -f 2 | sed -e s/[^[:alnum:]]//g | sed s/[0-9]//g)
tld=""

# Default to a Desktop
prefixLetter=""

isMacbook=$(echo $model | grep "Book")
if [[ $isMacbook != "" ]]; then
    prefixLetter="MBP-"
fi

isIMac=$(echo $model | grep "iMAC")
if [[ $isIMac != "" ]]; then
    prefixLetter="iMac-"
fi
isMacPro=$(echo $model | grep "MacPro")
if [[ $isMacPro != "" ]]; then
    prefixLetter="IMAC-"
fi
isMBA=$(echo $model | grep "Air")
if [[ $isMBA != "" ]]; then
    prefixLetter="MBA-"
fi

case "$prefixLetter" in 
    "V") # Do nothing to Virtual Machines
        echo "VMware VM, skipping rename" 
        ;;
    *)
        scutil --set ComputerName "${prefixLetter}${Department}-${serial}"
        scutil --set LocalHostName "${prefixLetter}${Department}-${serial}${tld}"
        scutil --set HostName "${prefixLetter}${Department}-${serial}${tld}"
        echo "${prefixLetter}${Department}-${serial}${tld}"
        echo "${prefixLetter}${Department}-${serial}${tld}"
        echo "${prefixLetter}${Department}-${serial}${tld}"
            ;;
esac
sleep 10
sudo jamf recon
