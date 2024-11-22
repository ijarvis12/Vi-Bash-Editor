#!/usr/bin/env bash

set -o emacs

GFILE="$@"

bind "set horizontal-scroll-mode ON"
bind "set blink-matching-paren ON"
bind -m emacs '"\e[A":previous-screen-line'
bind -m emacs '"\e[B":next-screen-line'
bind -m emacs '"\n":self-insert'
bind -m emacs '"\r":"\n"'
bind -m emacs '"\t":tab-insert'
bind -m emacs '"\C-d":accept-line'

INSERT_TEXT="$(if [[ -n $GFILE && -e $GFILE ]]; then cat $GFILE; else echo; fi)"

IFS=

read -er -i "$INSERT_TEXT" gettext

bind -m emacs '"\n":accept-line'

if [[ -z "$GFILE" ]]; then read -er -p "Save as: " GFILE; fi

if [[ -n "$GFILE" ]]; then printf "$gettext" > "$GFILE"; fi
