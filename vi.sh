#!/usr/bin/env bash

set -o vi

IFS='\n\t '

GFILE="$1"

bind -m 'vi-insert' '"\e[A":previous-screen-line'
bind -m 'vi-insert' '"\e[B":next-screen-line'
bind -m 'vi-move' '"k":previous-screen-line'
bind -m 'vi-move' '"j":next-screen-line'
bind -m 'vi-insert' '"\r":self-insert'
bind -m 'vi-insert' '"\t":self-insert'

read -er -i "$(cat $GFILE)" gettext

if [[ -z "$GFILE" ]]; then
  read -er -p "Save as: " GFILE
fi

if [[ -n "$GFILE" ]]; then
  echo -e "$gettext" > "$GFILE"
fi
