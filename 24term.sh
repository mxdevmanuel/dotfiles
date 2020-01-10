#!/bin/sh

echo "# 24-bit (true-color)"
# based on: https://gist.github.com/XVilka/8346728
term_cols="$(tput cols || echo 80)"
cols=$(echo "2^((l($term_cols)/l(2))-1)" | bc -l 2> /dev/null)
rows=$(( cols / 2 ))
awk -v cols="$cols" -v rows="$rows" 'BEGIN{
    s="  ";
    m=cols+rows;
    for (row = 0; row<rows; row++) {
      for (col = 0; col<cols; col++) {
          i = row+col;
          r = 255-(i*255/m);
          g = (i*510/m);
          b = (i*255/m);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,(col+row)%2+1,1);
      }
      printf "\n";
    }
    printf "\n\n";
}'

echo "# text decorations"
echo '[1mbold[22m'
echo '[2mdim[22m'
echo '[3mitalic[23m'
echo '[4munderline[24m'
echo '[4:1mthis is also underline[4:0m'
echo '[21mdouble underline[24m'
echo '[4:2mthis is also double underline[4:0m'
echo '[4:3mcurly underline[4:0m'
echo '[58;5;10;4mcolored underline[59;4:0m'
echo '[5mblink[25m'
echo '[7mreverse[27m'
echo '[8minvisible[28m <- invisible (but copy-pasteable)'
echo '[9mstrikethrough[29m'
echo '[53moverline[55m'
echo

echo "# magic string (see https://en.wikipedia.org/wiki/Unicode#Web)"
echo "é Δ Й ק م ๗ あ 叶 葉 말"
echo

echo "# emojis"
echo "😃😱😵"
echo

echo "# right-to-left ('w' symbol should be at right side)"
echo "שרה"
echo

echo "# sixel graphics"
printf 'P0;0;0q"1;1;64;64#0;2;0;0;0#1;2;100;100;100#1~{wo_!11?@FN^!34~^NB
@?_ow{~$#0?BFN^!11~}wo_!34?_o{}~^NFB-#1!5~}{o_!12?BF^!25~^NB@??ow{!6~$#0!5?
@BN^!12~{w_!25?_o{}~~NFB-#1!10~}w_!12?@BN^!15~^NFB@?_w{}!10~$#0!10?@F^!12~}
{o_!15?_ow{}~^FB@-#1!14~}{o_!11?@BF^!7~^FB??_ow}!15~$#0!14?@BN^!11~}{w_!7?_
w{~~^NF@-#1!18~}{wo!11?_r^FB@??ow}!20~$#0!18?@BFN!11~^K_w{}~~NF@-#1!23~M!4?
_oWMF@!6?BN^!21~$#0!23?p!4~^Nfpw}!6~{o_-#1!18~^NB@?_ow{}~wo!12?@BFN!17~$#0!
18?_o{}~^NFB@?FN!12~}{wo-#1!13~^NB@??_w{}!9~}{w_!12?BFN^!12~$#0!13?_o{}~~^F
B@!9?@BF^!12~{wo_-#1!8~^NFB@?_w{}!19~{wo_!11?@BN^!8~$#0!8?_ow{}~^FB@!19?BFN
^!11~}{o_-#1!4~^NB@?_ow{!28~}{o_!12?BF^!4~$#0!4?_o{}~^NFB!28?@BN^!12~{w_-#1
NB@???GM!38NMG!13?@BN$#0?KMNNNF@!38?@F!13NMK-\'
