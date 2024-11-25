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

# enable alt buffer screen and place cursor at top
printf "\e[?1049h\e[H"

INSERT_TEXT="$(if [[ -n $GFILE && -e $GFILE ]]; then cat $GFILE; fi)"

IFS=

read -er -i "$INSERT_TEXT"

bind -m emacs '"\n":accept-line'
bind -m emacs '"\r":accept-line'

if [[ -z "$GFILE" ]]; then
  # place curosr at bottom
  printf "\e[$LINES;0H"
  read -er -p "Save as: " GFILE
fi

if [[ -n "$GFILE" ]]; then printf "$REPLY" > "$GFILE"; fi

# disable alt buffer screen
printf "\e[?1049l"
