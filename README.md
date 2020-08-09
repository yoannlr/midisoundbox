# Midi Soundbox: use a MIDI instrument to trigger sounds

A command line MIDI Soundbox.

## Command line arguments

* `-l` : lists MIDI devices
* `-i <device>` : sets MIDI input device (device id looks something like `hw:3`)
* `-d <path>` : sets soundbox directory (the location of all sound files)
* `-c <file>` : sets configuration file (see `soundbox.conf` for an example)
* `-m` : shows a message for each note, useful to get key ids
* `-h` : displays an help message

You are required to specify the `-i` option since it doesn't have a default value.

## Requirements

* mpv - media player
* amidi - alsa midi, part of alsa-utils package on Arch Linux
