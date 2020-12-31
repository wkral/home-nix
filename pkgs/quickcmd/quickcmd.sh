#! /usr/bin/env bash

cache=${XDG_CACHE_HOME:=~/.cache}/wofi-quickcmd
woficmd="wofi --cache-file=$cache --show dmenu"
cmddir="$(dirname $0)/../cmds/"
cmd=$(ls -1 ${cmddir} | $woficmd)
${cmddir}/$cmd >/dev/null
