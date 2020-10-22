#!/bin/bash
#Removes configuration profiles per the identifier.

# profile identifier
PROID=.com.crx.CapitalProjectSearchmbbfkmhmakcjkcoonpdnoccmlkedgemf

# check to see if the profile is installed on the machine, and attempt to remove it if found.
    if [[ $(profiles -C | grep "${PROID}") ]]; then 
        profiles -R -p "${PROID}"
        if [[  $(profiles -C | grep "${PROID}") ]]; then
            echo "Removeal of ${PROID} failed. Exiting"
            exit 1
        else
            echo "Removal of ${PROID} successful."
        fi
    fi

    sudo jamf recon