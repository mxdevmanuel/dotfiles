#!/usr/bin/env bash
# Script  to configure services that require multiple commands
# involving firewall and services commands and its reversion
# for services we don't want to start nor keep their ports
# open permanently.

# Get command line [parameter]
parameter=$1

# if in  terminal se fzf instead of dmenu
TOOL=dmenu\ -p\ "services"
if [[ -t 1 ]]; then
        TOOL=fzf
fi
# Select a service
option=$(echo -e "ssh\nsamba" | $TOOL)

case $option in
        "ssh")
                if [[ "$parameter" == "start" ]]
                then
                        ufw limit from 192.168.100.0/24 to any port 22
                        systemctl start sshd
                elif [[ "$parameter" == "stop" ]]
                then
                        ufw delete limit from 192.168.100.0/24 to any port 22
                        systemctl disable sshd
                fi
                ;;
        "samba")
                if [[ "$parameter" == "start" ]]
                then
                        ufw allow samba
                        systemctl start smb.service
                        systemctl start nmb.service
                elif [[ "$parameter" == "stop" ]]
                then
                        ufw delete allow samba
                        systemctl disable smb.service
                        systemctl disable nmb.service
                fi
                ;;
esac




