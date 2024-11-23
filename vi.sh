#!/usr/bin/env bash

set -o vi

GFILE="$@"

bind "set blink-matching-paren ON"
bind "set horizontal-scroll-mode ON"
bind -m vi-insert '"\e[A":previous-screen-line'
bind -m vi-insert '"\e[B":next-screen-line'
bind -m vi-move '"k":previous-screen-line'
bind -m vi-move '"j":next-screen-line'
bind -m vi-move '"\n":next-screen-line'
bind -m vi-move '"\r":next-screen-line'
bind -m vi-move '"o":"i\n"'
bind -m vi-move '"O":"I\n"'
bind -m vi-insert '"\n":self-insert'
bind -m vi-insert '"\r":"\n"'
bind -m vi-insert '"\t":tab-insert'

INSERT_TEXT=$(if [[ -n "$GFILE" && -e "$GFILE" ]]; then cat "$GFILE"; fi)

IFS=

read -e -i "$INSERT_TEXT" GETTEXT

bind -m vi-insert '"\n":accept-line'
bind -m vi-insert '"\r":accept-line'

if [[ -z "$GFILE" ]]; then read -er -p "Save as: " GFILE; fi

if [[ -n "$GFILE" ]]; then printf "$GETTEXT" > "$GFILE"; fi
