#!/usr/bin/env bash
# Script  to configure services that require multiple commands
# involving firewall and services commands and its reversion
# for services we don't want to start nor keep their ports
# open permanently.

# Get command line [parameter]
parameter=$1

if [[ -z "$parameter" ]]
then
	echo "Missing operand start|stop"
	exit 2
fi

# if in  terminal se fzf instead of dmenu
TOOL=dmenu\ -p\ "services"
DO=pkexec

if [[ -t 1 ]]; then
        TOOL=fzf
        DO=sudo
fi

# Select a service
option=$(echo -e "ssh\nsamba" | $TOOL)

FILE="/tmp/enabler.sh"

if [[  -f "$FILE" ]]
then
        truncate -s 0 $FILE
else
        touch $FILE
fi

echo "#!/usr/bin/env bash" >> $FILE

case $option in
        "ssh")
                if [[ "$parameter" == "start" ]]
                then
                        echo "ufw limit from 192.168.100.0/24 to any port 22" >> $FILE
                        echo "systemctl start sshd" >> $FILE
                elif [[ "$parameter" == "stop" ]]
                then
                        echo "ufw delete limit from 192.168.100.0/24 to any port 22" >> $FILE
                        echo "systemctl disable sshd" >> $FILE
                fi
                ;;
        "samba")
                if [[ "$parameter" == "start" ]]
                then
                        echo "ufw allow samba" >> $FILE
                        echo "systemctl start smb.service" >> $FILE
                        echo "systemctl start nmb.service" >> $FILE
                elif [[ "$parameter" == "stop" ]]
                then
                        echo "ufw delete allow samba" >> $FILE
                        echo "systemctl disable smb.service" >> $FILE
                        echo "systemctl disable nmb.service" >> $FILE
                fi
                ;;
esac

chmod a+x $FILE

$DO $FILE

rm $FILE


