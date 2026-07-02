SCRIPT_DIR=`dirname $0`
MONITOR_LIST_DIR="list"

cd $SCRIPT_DIR
sh update-config.sh

cd $MONITOR_LIST_DIR
for name in `ls`; do 
    cd $name
        primary=`cat primary`
        resolution=`cat resolution`
        rotation=`cat rotation`
        pos=`cat pos`
        scale=`cat scale`
        desktops=`cat desktops`
        xrandr --output $name\
                    `[ $primary = true ] && echo --primary`\
                    --mode $resolution\
                    --pos $pos\
                    --rotate $rotation\
                    --scale $scale &&\
            bspc monitor $name -d $desktops


    cd ..
done

echo "Xft.dpi: 96" > ~/.Xresources
xrdb -merge ~/.Xresources

cd ..
feh --bg-scale wallpapers/{gruvbox-dark-1080x1920.png,gruvbox-dark-1920x1080.png}