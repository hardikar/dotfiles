#/bin/sh
# Author: hardikar@cs.wisc.edu
# Shamelessly copied and updated from 
# https://github.com/graysky2/checkip/blob/master/common/checkip.in
#
# This is a simple script that checks if the external IP address of this computer was changed
# and sends and email out to $MAILTO using $(mail) as configured with $HOME/.mailrc or otherwise.
# Also add this to CRON using:
#    crontab -e
#    */30 * * * * $HOME/bin/checkip.sh
# for running this script every 30mins.

# Configuration
function setup_config(){
    # Stores old ip address for comparison
    DB="$HOME/.config/ip/oldip"
    PROXY=
    MAILTO='shreedharhardikar@gmail.com'
    LOGFILE="$HOME/.config/ip/checkip.log"
    # Log size before it rotates to $LOGFILE.old (in bytes)
    LOGROLLSIZE=$((50*1024*1024)) # 50 MB
}

# Edit this function to update action to take when the external IP address changes
# I have my e-mail settings configured in ~/.mailrc and not source controlled
function mailme(){
    SUBJECT="[CHECKIP] External IP addr change noticed"
    echo "
        External IP Address change noticed at $NOW!
        OLD IP ADDR = $OLDIP
        NEW IP ADDR = $CURRENTIP
    " | mail -s "$SUBJECT" "$MAILTO"
    writelog INFO "Sending e-mail to $MAILTO..."
    if [[ -n $? ]]; then
        writelog INFO "Sent!"
    else
        writelog ERROR "Error while sending e-mail."
    fi
}


function initlog(){
    # If the log file gets too big move it
    if [[ -f "$LOGFILE" && $(stat --printf="%s" "$LOGFILE") -gt "$LOGROLLSIZE" ]]; then
        mv "$LOGFILE" "$LOGFILE.old"
    fi

    # Create one if it doesn't already exist
    if [[ ! -f $LOGFILE ]]; then
        mkdir -p $(dirname "$LOGFILE") && touch "$LOGFILE"
    fi
}

function writelog(){
    NOW=$(date "+%m-%d-%Y %H:%M:%S")
    echo $NOW $* >> "$LOGFILE"
}

function oldip(){
    writelog INFO "Looking at '$DB' for old IP address..."
    if [[ ! -f "$DB" ]]; then
        writelog INFO "No old IP on record."
    else
        OLDIP=$(cat "$DB")
        writelog INFO "Found $DB. Old IP address: $OLDIP"
    fi
}

function checkip(){
    # Get the IP address
    # Script tries initially from a DNS server using dig
    writelog INFO "Checking external ip..."

    CURRENTIP=$(dig +short myip.opendns.com @resolver1.opendns.com)

    # If that fails, it defaults back to using websites
    # that provide the IP trying all three of these:
    # 1. http://www.whatsmyip.us
    # 2. http://icanhazip.com
    # 3. http://ifconfig.me
    if [[ -z "$CURRENTIP" ]]; then
        CURRENTIP=$(curl $PROXY -s http://www.whatsmyip.us/ | grep "</textarea>"| sed 's/[</].*$//')
    fi

    if [[ -z "$CURRENTIP" ]]; then
        CURRENTIP=$(curl $PROXY -s http://icanhazip.com/)
    fi

    if [[ -z "$CURRENTIP" ]]; then
        CURRENTIP=$(curl $PROXY -s http://ifconfig.me/)
    fi

    if [[ -z "$CURRENTIP" ]]; then
        # net up or down
        writelog ERROR "WAN or websites are down, no action taken."
    else
        writelog INFO "External IP address : $CURRENTIP"
    fi
}

function main(){
    setup_config && initlog
    # Set up $OLDIP
    oldip
    if [[ -z "$OLDIP" ]]; then
        # Create the directory $DB is going to sit in
        mkdir -p $(dirname "$DB")
    fi

    checkip
    if [[ "$OLDIP" == "$CURRENTIP" ]]; then
        writelog INFO "Old and current ips match! No action taken."
    else
        writelog INFO "Old and current ips do not match!"
        echo "$CURRENTIP" > "$DB"
        mailme
    fi
}
main

