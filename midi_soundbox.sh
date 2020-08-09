#!/bin/sh

# Requirements
# - amidi (part of alsa-utils on Arch)
# - mpv

SOUNDBOXDIR='soundbox/'
CONFIGFILE='soundbox.conf'
LOG=
DEVICE=

usage() {
echo '-i   set MIDI input device (use -l to list devices)
-d dir   set soundbox directory
-c config   set configuration file
-l   list MIDI devices
-h   show this message
-m   display a message for each note'
}

[ $# -eq 0 ] && usage && exit

while getopts 'mhlc:d:i:' c
do
	case $c in
		'h') usage ;;
		'l') amidi -l ; exit 0 ;;
		'c') CONFIGFILE="$OPTARG" ;;
		'i') DEVICE="$OPTARG" ;;
		'd') SOUNDBOXDIR="$OPTARG" ;;
		'm') LOG=1 ;;
	esac
done

CONFIG=$(cat "$CONFIGFILE")

printnotes() {
	while read midi
	do
		egrep '^90' <<< "$midi" > /dev/null && cut -d' ' -f2 <<< "$midi"
	done
}

handle() {
	PLAY=''
	while read note
	do
		VOL='100'
		PLAY=$(egrep "^$note" <<< "$CONFIG" | cut -d' ' -f2)
		[ ! -z $LOG ] && echo "$(date) : $note = $PLAY"
		if [ ! -z "$PLAY" ]
		then
			PLAY="$SOUNDBOXDIR/$PLAY"
			if grep ':' <<< "$PLAY" > /dev/null
			then
				VOL=$(cut -d':' -f2 <<< "$PLAY")
				PLAY=$(cut -d':' -f1 <<< "$PLAY")
			fi
			[ ! -z $PLAY ] && mpv --no-video --volume="$VOL" "$PLAY" &> /dev/null &
		fi
	done
}

amidi -p "$DEVICE" -d | printnotes | handle
