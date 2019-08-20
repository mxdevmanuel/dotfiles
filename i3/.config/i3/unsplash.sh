LAND=~/Imágenes/Wallpapers/Unsplash/$(date -d "today" +"%Y%m%d").jpg
wget "https://source.unsplash.com/featured/1920x1080/daily/?landscape" -O $LAND

ARCH=~/Imágenes/Wallpapers/Architecture/$(date -d "today" +"%Y%m%d").jpg
wget "https://source.unsplash.com/featured/1921x1080/daily/?architecture" -O $ARCH
DOW=$(date +%u)

if (( $DOW % 2 ))
then
	feh --bg-fill $ARCH
else
	feh --bg-fill $LAND
fi
