#!/bin/sh
#
# ancistrus
#
# Netgear's D7000 Nighthawk Router Experience Distributed Project
#
# https://github.com/negan07/ancistrus
#
# License: GPLv2
#
#
# Led script: playing with led boards.
#
# Usage: $0 <kitt|halfkitt|kittwake|halfkittwake|bright|dark|reset|help>
#
# Methods are:
# kitt) "supercar" K.I.T.T. mode - leds run from left to right & back
# halfkitt) left and right led sides run from opposite and meet in the middle then back
# kittwake) same as kitt with wake effect - one led on, the next on before the previous off
# halfkittwake) halfkitt+kittwake together
# bright) all on white + amber
# dark) all off white + amber
# reset) return to leds normal working conditions
# help) brief led board guide
#

FUNC=void
LD=led_app
DELAY=2000				# setup delay between led's each other transitions: assume value like ns
WAKEDELAY=250				# setup delay between 2nd led on and then first off: assume value like ns
LEDW="70 20 50 41 42 61 60 11 13 15 17 40 45"
LEDWB="40 17 15 13 11 60 61 42 41 50 20"
LEDWL="70 20 50 41 42 61 60"
LEDWLB="61 42 41 50 20"
LEDWR="11 13 15 17 40"
LEDWRB="45 40 17 15 13 11 60"
LEDA="71 30 10 12 14 16"

USLEEP() {				# insert some delay between led actions: sleep is too slow so use this counter as workaround for ns
[ ! -z $1 ] && DELAY=$1
C=0
	while [ $C -le $DELAY ]
	do
#	C=`expr $C + 1`
	C=$(( $C + 1 ))
	done
}

KITT() {				# K.I.T.T. mode: one led on/off after another and then come back
	for L in $*
	do
	$LD on $L
	USLEEP
	$LD off $L
	shift
	done
}

KITT_WAKE() {				# K.I.T.T. wake mode: one led on, the next on before the previous off and so on and then come back
$LD on $1
	for L in $*
	do
	[ $# -eq 1 ] && USLEEP $WAKEDELAY && $LD off $1 && break
	USLEEP
	$LD on $2
	USLEEP $WAKEDELAY
	$LD off $1
	shift
	done
}

ALL_LED_ON() {				# bright the router without turning led_app ctrl on
$LD ctrl no_blink_data
	for L in ${LEDW} ${LEDA}
	do
	$LD on $L
	done
}

ALL_LED_OFF() {				# dark the router without turning led_app ctrl off
$LD ctrl no_blink_data
	for L in ${LEDW} ${LEDA}
	do
	$LD off $L
	done
}

LOOP_EXIT() {				# exit loop and exit
ALL_LED_OFF
$LD off 71 & $LD on 70
echo
echo "Set leds normal working condition with:"
echo "$0 reset"
echo "about twice"
echo "Leds need some seconds to be waken up properly"
exit 0
}

LED_RESET() {				# bring leds back to normal working condition and exit: maybe it needs to be called twice to work
$LD off 71 & $LD on 70
$LD ctrl off
rc led_ctrl restart
exit 0
}

LED_GUIDE() {
cat << _EOF_
#
# ancistrus
#
# Netgear's D7000 Nighthawk Router Experience Distributed Project
#
# https://github.com/negan07/ancistrus
#
# License: GPLv2
#
#
# Led script: playing with led boards.
#
Usage: $0 <kitt|halfkitt|kittwake|halfkittwake|bright|dark|reset|help>

Methods are:
kitt) "supercar" K.I.T.T. mode - leds run from left to right & back
halfkitt) left and right led sides run from opposite and meet in the middle then back
kittwake) same as kitt with wake effect - one led on, the next on before the previous off
halfkittwake) halfkitt+kittwake together
bright) all on white + amber
dark) all off white + amber
reset) return to leds normal working conditions
help) brief led board guide

Leds are treated with sercomm command:
/usr/sbin/led_app

and the cumulative rc command:
/usr/sbin/rc_app/rc_led_ctrl <start|stop|restart>

Here's the typical led_app usage:
led_app on <led id>
led_app off <led id>
led_app blink <led id> <blink count> <on time> <off time>
led_app blink_always <led id> <blink count> <on time> <off time> <blink interval>
led_app blink_alt <led id> <led id2> <blink count> <on time> <off time>
led_app blink_tm <led id> <led id2> <blink count> <on time> <off time> <blink interval>
led_app reboot <secs>
led_app ctrl <blink_data|no_blink_data|off>

Legend:
<led id> = led id number: each led corresponds to a number (some leds are white/amber and the colour has a different number)
<blink count> = stands for number of blinks
<on time> = duty cycle led on for blinking (in ms)
<off time> = duty cycle led off from blinking (in ms)
<blink interval> = interval between blinking (in ms)
<secs> = seconds

Functions:
on = turn led on
off = turn led off
blink = one led blinking for a specified time
blink_always = one led blinking for unspecified time
blink_alt = blink two leds alternatively for unspecified time
blink_tm = blink two leds alternatively for a specified time
reboot = reboot led (and machine) in X seconds

e.g.
led_app blink_always 71 1 250 750 0

Many combinations may be done varying commands, duty cycles, intervals and delays.

<led id> specs
From left (power) to right (wps)

70 power white - 71 power amber
20 internet link white - 30 internet link amber
50 adsl link white
41 wifi 2.4ghz white
42 wifi 5ghz white
61 storage #1 left white
60 storage #2 right white
10 lan #1 amber - 11 lan #1 white
12 lan #2 amber - 13 lan #2 white
14 lan #3 amber - 15 lan #3 white
16 lan #4 amber - 17 lan #4 white
40 wifi radio button white
45 wps radio button white

/
| 70/71    20/30    50    41    42    61    60    10/11    12/13    14/15    16/17    40    45  |
| pwr      link     adsl  wifi  wifi5 usbl  usbr  eth1     eth2     eth3     eth4     wifi  wps |
|_______________________________________________________________________________________________|
_EOF_
}

[ ! -z "$1" ] && FUNC=$1

	case $FUNC in
	kitt|halfkitt|kittwake|halfkittwake)
	;;
	bright)
	ALL_LED_ON
	exit 0
	;;
	dark)
	ALL_LED_OFF
	exit 0
	;;
	reset)
	LED_RESET
	;;
	help)
	LED_GUIDE
	exit 0
	;;
	*)
	echo "Usage: $0 <kitt|halfkitt|kittwake|halfkittwake|bright|dark|reset|help>" && exit 1
	esac

# initializing...
echo "Starting $FUNC led mode..."
echo "Press CTRL+C to exit"
ALL_LED_OFF

# trap the CTRL+C and revert leds back to normal working condition and exit
trap LOOP_EXIT SIGINT SIGTERM

#non stop looping: press CTRL+C to exit
while [ 1 ]
do
	case $FUNC in
	kitt)
	set -- ${LEDW} ${LEDWB}
	KITT $*
	;;
	halfkitt)
	set -- ${LEDWL} ${LEDWLB}
	LEFT=$*
	set -- ${LEDWRB} ${LEDWR}
	RIGHT=$*
	KITT $LEFT & KITT $RIGHT
	;;
	kittwake)
	set -- ${LEDW} ${LEDWB}
	KITT_WAKE $*
	;;
	halfkittwake)
	set -- ${LEDWL} ${LEDWLB}
	LEFT=$*
	set -- ${LEDWRB} ${LEDWR}
	RIGHT=$*
	KITT_WAKE $LEFT & KITT_WAKE $RIGHT
	;;
	*)
	;;
	esac
done

