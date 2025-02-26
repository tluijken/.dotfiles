#!/bin/sh

common() {
    echo -n "{"
    #echo -n "\"separator_block_width\":0,"
    echo -n "\"color\":\"$fg\","
    echo -n "\"background\":\"$bg\","
    echo -n "\"name\":\"$name\","
    echo -n "\"full_text\":\" $stat \","
    echo -n "},"
}

battery0() {
local bg="#282828"
local fg="#fbf1c7"
local name="battery0"
prct=$(cat /sys/class/power_supply/BAT0/capacity)
chrg=$(cat /sys/class/power_supply/BAT0/status)
icon=" "
case $chrg in
    "Charging")  icon="󰂄";fg="#83a598";;
    "Not charging") icon="󰠑" ;fg="#fe8019";;
    "Unknown") icon="";fg="#fb4934";;
    "Full") icon="⚡"; bg="#282828";;
esac 
local stat=$icon\ $prct
common
}

mydate() {
local bg="#282828"
local fg="#fbf1c7"
local name="id_time"
local stat=$(date "+%a-%b-%d %H:%M")
common
}

volume() {
local bg="#282828"
local fg="#fbf1c7"
local name="id_volume"
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d : -f 2)
vol="󰕾$vol"
echo $vol | grep 'MUTED' >/dev/null  &&  bg="FF0000" && vol=" "
local stat=${vol}
common
}

echo '{ "version": 1 , "click_events":false}'
echo '[[],'

while :
do
    echo -n "[ "
    mydate
    volume
    battery0
    echo -n " ],"
    sleep 1
done
