#!/usr/bin/env bash

set -o emacs

GFILE="$@"

bind "set blink-matching-paren ON"
bind "set horizontal-scroll-mode OFF"
bind -m emacs '"\e[A":previous-screen-line'
bind -m emacs '"\e[B":next-screen-line'
bind -m emacs '"\C-p":previous-screen-line'
bind -m emacs '"\C-n":next-screen-line'

GETTEXT=

newline-insert() {
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}"$'\n'"${READLINE_LINE:$READLINE_POINT:${#READLINE_LINE} - $READLINE_POINT}"
  READLINE_POINT+=1
  GETTEXT="$READLINE_LINE"
}

bind -m emacs -x '"\n":newline-insert'
bind -m emacs '"\r":"\n"'
bind -m emacs '"\t":tab-insert'
bind -m emacs-ctlx '"s":accept-line'

INSERT_TEXT=$(if [[ -n "$GFILE" && -e "$GFILE" ]]; then cat "$GFILE"; fi)

IFS=

read -er -i "$INSERT_TEXT"

bind -m emacs '"\n":accept-line'

if [[ -z "$GFILE" ]]; then read -er -p "Save as: " GFILE; fi

if [[ -n "$GFILE" ]]; then printf "$GETTEXT" > "$GFILE"; fi
