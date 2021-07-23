CHROME=$(pgrep chrome)
if [ ! -z "$CHROME" ]
then
        google-chrome-stable $1 > /dev/null 2>&1
        exit 0
fi

CHROMIUM=$(pgrep chromium)
if [ ! -z "$CHROMIUM"  ]
then
        chromium $1 > /dev/null 2>&1
        exit 0
fi

vimb $1 > /dev/null 2>&1
