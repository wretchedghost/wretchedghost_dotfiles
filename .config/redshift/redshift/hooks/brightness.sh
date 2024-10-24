#!/bin/sh

# Set brightness via xbrightness when redshift status changes

# Set brightness values for each status.
# Range from 1 to 100 is valid
brightness_day=100
brightness_transition=50
brightness_night=30
# Set fade time for changes to one minute
fade_time=60000

set_brightness() {
	for backlight in "${backlights[@]}"
	do
		xbacklight -set $1 -fps $fps -ctrl $backlight &
	done
}

if [ "$1" = period-changed ]; then
	case $3 in
		night)
			xbacklight -set $brightness_night -time $fade_time
			;;
		transition)
			xbacklight -set $brightness_transition -time $fade_time
			;;
		daytime)
			xbacklight -set $brightness_day -time $fade_time
			;;
	esac
fi
