#!/bin/bash

# this script manages displaying the current power draw using Generic Monitor gnome shell extension
# https://extensions.gnome.org/extension/2826/generic-monitor/

if [ $# -ne 1 ]; then
    echo "update_power <refresh_period>"
    exit 1
fi

battery_path="/sys/class/power_supply/BAT0"

function close_box() {
    gdbus call --session --dest org.gnome.Shell --object-path /com/soutade/GenericMonitor --method com.soutade.GenericMonitor.deleteGroups '{"groups":["power"]}'
}

trap 'close_box' 0 # EXIT

while true; do
    # UPower has a refresh delay, forcing refresh reads "Not implemented"
    # busctl call --system org.freedesktop.UPower /org/freedesktop/UPower/devices/battery_BAT0 org.freedesktop.UPower.Device Refresh
    # reading=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "energy-rate"|xargs|cut -d' ' -f2`
    current=`cat ${battery_path}/current_now`
    voltage=`cat ${battery_path}/voltage_now`
    reading=`echo "scale=2; ${current}*${voltage}/1000000000000" | bc`

    printf '{"group":"power","items":[{"name":"first","box":"right","text":{"text":"%.2f W"}}]}' ${reading/./,} | xargs -0 gdbus call --session --dest org.gnome.Shell --object-path /com/soutade/GenericMonitor --method com.soutade.GenericMonitor.notify
    sleep $1
done
