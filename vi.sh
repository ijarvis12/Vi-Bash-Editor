#!/usr/bin/env bash

set -o vi

GFILE="$@"

bind "set horizontal-scroll-mode ON"
bind "set blink-matching-paren ON"
bind -m vi-insert '"\e[A":previous-screen-line'
bind -m vi-insert '"\e[B":next-screen-line'
bind -m vi-move '"k":previous-screen-line'
bind -m vi-move '"j":next-screen-line'
bind -m vi-insert '"\n":self-insert'
bind -m vi-insert '"\r":"\n"'
bind -m vi-insert '"\t":self-insert'

INSERT_TEXT="$(if [[ -n $GFILE && -e $GFILE ]]; then cat $GFILE; else echo; fi)"

IFS=

read -er -d $'\04' -i "$INSERT_TEXT" gettext

bind -m vi-insert '"\n":accept-line'
bind -m vi-insert '"\r":accept-line'

if [[ -z "$GFILE" ]]; then read -er -p "Save as: " GFILE; fi

if [[ -n "$GFILE" ]]; then echo "$gettext" > "$GFILE"; fi
