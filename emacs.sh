#!/usr/bin/env bash

set -o emacs

GFILE="$@"

bind "set blink-matching-paren ON"
bind "set horizontal-scroll-mode OFF"
bind -m emacs '"\e[A":previous-screen-line'
bind -m emacs '"\e[B":next-screen-line'
bind -m emacs '"\C-p":previous-screen-line'
bind -m emacs '"\C-n":next-screen-line'
bind -m emacs '"\n":self-insert'
bind -m emacs '"\r":"\n"'
bind -m emacs '"\t":tab-insert'
bind -m emacs-ctlx '"s":accept-line'

if [[ -n "$GFILE" && -e "$GFILE" ]]; then INSERT_TEXT=$(<"$GFILE"); else INSERT_TEXT=""; fi

IFS=

read -er -d$'\04' -i "$INSERT_TEXT" GETTEXT

bind -m emacs '"\n":accept-line'
bind -m emacs '"\r":accept-line'

if [[ -z "$GFILE" ]]; then read -er -p "Save as: " GFILE; fi

if [[ -n "$GFILE" ]]; then echo "$GETTEXT" > "$GFILE"; fi
