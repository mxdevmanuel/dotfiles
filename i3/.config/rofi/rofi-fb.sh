STATUS=$(ls -l $1 | grep '^d' | awk '{print $9}' | rofi -dmenu -kb-custom-1 'Alt+a' -kb-custom-2 'Alt+p')

excode=$?
rdir=$1
if test $excode -eq 1
then
	exit 0
fi

STATUS=$(echo $STATUS | sed 's?^?'`echo $rdir`'/?')

if test $excode -eq 0
then
	bash /home/$USER/.config/rofi/rofi-fb.sh $STATUS
fi

if test $excode -eq 11
then
	bash /home/$USER/.config/rofi/rofi-fb.sh $(dirname "$rdir")
fi

if test $excode -eq 10
then
	pcmanfm $STATUS
fi
