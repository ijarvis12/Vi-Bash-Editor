#!/usr/bin/env bash

set -o vi

IFS='\n\t '

GFILE="$1"

TOP_ROW=0

declare -a gettext
if [[ -n "$GFILE" && -e "$GFILE" ]]; then
  mapfile gettext < "$GFILE"
fi

function move_up() {
  # Go back to beginning of line
  GLINE=$(echo "${READLINE_LINE:0:$READLINE_POINT}" | tail -n 1)
  let "index = ${#GLINE}"
  let "READLINE_POINT -= $index"

  # Go back to end of previous line (maybe)
  if [[ $READLINE_POINT -gt 0 ]]; then
    let "READLINE_POINT -= 1"
  elif [[ $TOP_ROW -gt 0 ]]; then
    let "i = $TOP_ROW"
    for line in "$READLINE_LINE"; do
      gettext[$i]="$line"
      let "i += 1"
    done
    let "TOP_ROW -= 1"
    READLINE_LINE=$(echo -e "${gettext[@]:$TOP_ROW:$LINES}" | sed 's/ //')
  fi

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
  if [[ $READLINE_POINT -lt ${#READLINE_LINE} ]]; then
    let "READLINE_POINT += 1"
  elif [[ $LINES -ge $TOP_ROW && $(($LINES - $TOP_ROW)) -lt ${#gettext[@]} ]]; then
    let "i = $TOP_ROW"
    for line in "$READLINE_LINE"; do
      gettext[$i]="$line"
      let "i += 1"
    done
    let "TOP_ROW += 1"
    READLINE_LINE=$(echo -e "${gettext[@]:$TOP_ROW:$LINES}" | sed 's/ //')
    let "READLINE_POINT = ${#READLINE_LINE}"
  elif [[ $TOP_ROW -gt $LINES && $(($TOP_ROW - $LINES)) -lt ${#gettext[@]} ]]; then
    let "i = $TOP_ROW"
    for line in "$READLINE_LINE"; do
      gettext[$i]="$line"
      let "i += 1"
    done
    let "TOP_ROW += 1"
    READLINE_LINE=$(echo -e "${gettext[@]:$TOP_ROW:$LINES}" | sed 's/ //')
    let "READLINE_POINT = ${#READLINE_LINE}"
  fi

  # Go to same amount as original line
  GLINE=$(echo "${READLINE_LINE:$READLINE_POINT:${#READLINE_LINE}}" | head -n 1)
  if [[ ${#GLINE} -ge $index ]]; then
    let "READLINE_POINT += $index"
  else
    let "READLINE_POINT += ${#GLINE}"
  fi
}

function newline_insert() {
  let "total_lines = 0"
  let "i = $TOP_ROW"
  for line in "$READLINE_LINE"; do
    let "total_lines += 1"
    gettext[$i]="$line"
    let "i += 1"
  done
  if [[ $total_lines -eq $LINES ]]; then
    let "TOP_ROW += 1"
    GLINE=$(echo "${READLINE_LINE:0:$READLINE_POINT}" | tail -n 1)
    let "READLINE_POINT -= ${#GLINE}"
    READLINE_LINE=$(echo -e "${gettext[@]:$TOP_ROW:$LINES}" | sed 's/ //')
  fi
  BEFORE_TEXT="${READLINE_LINE:0:$READLINE_POINT}"
  if [[ $READLINE_POINT -eq ${#READLINE_LINE} ]]; then
    AFTER_TEXT="\n\x04"
    READLINE_LINE=$(echo -en "$BEFORE_TEXT"; echo -en "$AFTER_TEXT")
  else
    AFTER_TEXT="${READLINE_LINE:$READLINE_POINT:$((${#READLINE_LINE} - $READLINE_POINT))}"
    READLINE_LINE=$(echo -e "$BEFORE_TEXT"; echo -en "$AFTER_TEXT")
  fi
  if [[ $total_lines -ne $LINES ]]; then
    let "READLINE_POINT += 1"
  fi
}

bind -m 'vi-insert' -x '"\e[A":move_up'
bind -m 'vi-insert' -x '"\e[B":move_down'
bind -m 'vi-move' -x '"k":move_up'
bind -m 'vi-move' -x '"j":move_down'
bind -m 'vi-insert' -x '"\r":newline_insert'

read -er -i "$(echo -e ${gettext[@]:$TOP_ROW:$LINES} | sed 's/ //')" _

if [[ -n "$GFILE" ]]; then
  echo -e "${gettext[@]}" | sed 's/ //' > "$GFILE"
fi
