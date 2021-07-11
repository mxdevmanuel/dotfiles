string=$(lsof -w +D /tmp | awk '{ print $9 }')

arr=("${(f)string}")


echo "@@@@@@@@@@@@@@@@@@@@@@"
print "Cleaning tempfiles"
echo "@@@@@@@@@@@@@@@@@@@@@@"
for filename in /tmp/**/*
do
        [[ -d "$filename" ]] && continue

        if (($arr[(Ie)$filename])); then
          print $filename
          echo value is amongst the values of the array
          continue
        else
                rm $filename
        fi

done
