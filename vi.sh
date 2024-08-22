#!/usr/bin/env bash

set -o vi

function move_up() {
  # Go back to beginning of line
  GLINE=$(echo "${READLINE_LINE:0:$READLINE_POINT}" | tail -n 1)
  let "index = ${#GLINE}"
  let "READLINE_POINT -= $index"

  # Go back to end of previous line (maybe)
  if [[ $READLINE_POINT -gt 0 ]]; then let "READLINE_POINT -= 1"; fi

  # Go back maybe same amount as original line
  GLINE=$(echo "${READLINE_LINE:0:$READLINE_POINT}" | tail -n 1)
  if [[ ${#GLINE} -ge $index ]]; then
    let "READLINE_POINT -= ${#GLINE} - $index"
  fi
}

function move_down() {
  # Get index from beginning of line
  GLINE=$(echo "${READLINE_LINE:0:$READLINE_POINT}" | tail -n 1)
  let "index = ${#GLINE}"

  # Go to end of line
  GLINE=$(echo "${READLINE_LINE:$READLINE_POINT:${#READLINE_LINE}}" | head -n 1)
  let "READLINE_POINT += ${#GLINE}"

  # Go to next line (maybe)
  if [[ $READLINE_POINT -lt ${#READLINE_LINE} ]]; then let "READLINE_POINT += 1"; fi

  # Go to same amount as original line
  GLINE=$(echo "${READLINE_LINE:$READLINE_POINT:${#READLINE_LINE}}" | head -n 1)
  if [[ ${#GLINE} -ge $index ]]; then
    let "READLINE_POINT += $index"
  else
    let "READLINE_POINT += ${#GLINE}"
  fi
}

function newline_insert() {
  BEFORE_TEXT="${READLINE_LINE:0:$READLINE_POINT}"
  if [[ $READLINE_POINT -eq ${#READLINE_LINE} ]]; then
    AFTER_TEXT="\n\x04"
    READLINE_LINE=$(echo -en "$BEFORE_TEXT"; echo -en "$AFTER_TEXT")
  else
    AFTER_TEXT="${READLINE_LINE:$READLINE_POINT:$((${#READLINE_LINE} - $READLINE_POINT))}"
    READLINE_LINE=$(echo -e "$BEFORE_TEXT"; echo -en "$AFTER_TEXT")
  fi
  let "READLINE_POINT += 1"
}

bind -m 'vi-insert' -x '"\e[A":move_up'
bind -m 'vi-insert' -x '"\e[B":move_down'
bind -m 'vi-move' -x '"k":move_up'
bind -m 'vi-move' -x '"j":move_down'
bind -m 'vi-insert' -x '"\r":newline_insert'

read -e -i "$(if [[ -n $1 && -e $1 ]]; then cat $1; fi)" -r gettext

if [[ -n "$1" ]]; then echo "$gettext" > "$1"; fi
