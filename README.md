# Vi-Bash-Editor
Vi Terminal Text Editor Written in GNU Bash


**Known bugs** (mostly the result of GNU Readline behavior):

- Text files larger than the terminal screen don't work well

- When horizontal-scroll-mode is set to ON, newline characters are printed as control character (^J) instead of inserting a newline


**Features I will NOT implement** (because of Unix functionality and philosophy)

- Multiple windows (instead use a terminal multiplexer like GNU Screen, tmux, or Zellij)

- Regex (use sed or awk)

- Word search (GNU Readline has builtin character search, if you need word search use grep)


**Features I will probably NOT implement** (because of GNU Readline functionality)

- Syntax highlighting

- Line numbering
