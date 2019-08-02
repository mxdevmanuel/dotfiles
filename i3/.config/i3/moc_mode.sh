running=$(pgrep mocp)

if [ -z $running ]
then
	termite -e "mocp -m"
else
	while sleep 1; do echo $(mocp -i | grep -i ^Title); done | dzen2 -w 1920
fi

