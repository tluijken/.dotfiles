#!/bin/sh
swaybg -i $(find ~/.dotfiles/wallpaper/. -type f | shuf -n1) -m fill &
OLD_PID=$!
while true; do
    sleep 6000
    swaybg -i $(find ~/.dotfiles/wallpaper/. -type f | shuf -n1) -m fill &
    NEXT_PID=$!
    sleep 5
    kill $OLD_PID
    OLD_PID=$NEXT_PID
done

# Dynamic wallpaper per hour of the day.
# https://louie.co.nz/25th_hour/
# #!/bin/sh
# cd projets/lakeside
# while true; do
#     PID=`pidof swaybg`
#     swaybg -i ./img/$(date -u -d @$((($(date -u +%s) / 600) * 600)) "+%Hh%M").png -m fill &
#     sleep 1
#     kill $PID
#     sleep 599
# done
