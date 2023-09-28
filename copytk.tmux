#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
	tmux show-options -g | grep "^${1} " | head -n1 | cut -d ' ' -f 2-
}
NOBINDS=0
NOMATCHES=0
if [ "`get_tmux_option '@copytk-no-default-binds'`" = 'on' ]; then NOBINDS=1; fi
if [ "`get_tmux_option '@copytk-no-default-matches'`" = 'on' ]; then NOMATCHES=1; fi

if [ $NOBINDS -eq 0 ]; then

# copytk prefix: easymotion action bindings
tmux bind-key -T copytk s run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-search --search-nkeys 1"
tmux bind-key -T copytk S run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-search --search-nkeys 2"
tmux bind-key -T copytk k run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-lines --search-direction backward"
tmux bind-key -T copytk j run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-lines --search-direction forward"
tmux bind-key -T copytk n run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-lines"

# copy mode: easymotion action bindings
tmux bind-key -T copy-mode-vi s run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-search --search-nkeys 1"
tmux bind-key -T copy-mode s run-shell -b "python3 $CURRENT_DIR/copytk.py easymotion-search --search-nkeys 1"

# tmux prefix: easycopy action bindings
tmux bind-key -T prefix f run-shell -b "python3 $CURRENT_DIR/copytk.py easycopy --search-nkeys 1"

# tmux prefix: quickcopy action bindings
tmux bind-key -T prefix \. run-shell -b "python3 $CURRENT_DIR/copytk.py quickcopy"

# bindings to enter copytk prefix
tmux bind-key -T copy-mode-vi S switch-client -T copytk
tmux bind-key -T copy-mode S switch-client -T copytk

fi


if [ $NOMATCHES -eq 0 ]; then

## Match quote-enclosed strings
tmux set -g @copytk-quickcopy-match-0-0 '"([^"\n]*)"'
tmux set -g @copytk-quickcopy-match-0-1 ''\''([^'\'\\'n]*)'\'
# Match URLs
tmux set -g @copytk-quickcopy-match-1-0 urls
## Match paths and filenames
tmux set -g @copytk-quickcopy-match-2-0 abspaths
tmux set -g @copytk-quickcopy-match-2-1 paths
tmux set -g @copytk-quickcopy-match-2-2 filenames
## Match IP addrs
tmux set -g @copytk-quickcopy-match-3-0 '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
## UUId:
tmux set -g @copytk-quickcopy-match-3-1 '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
## Hex
tmux set -g @copytk-quickcopy-match-4-0 '(0x[0-9a-fA-F]+)'
## Sha:
tmux set -g @copytk-quickcopy-match-4-1 '[0-9a-f]{7,128}'
## Digit:
tmux set -g @copytk-quickcopy-match-5-0 '\s[0-9]{4,}\s'
## Match whole lines
tmux set -g @copytk-quickcopy-match-6-0 '\S{4,}'

# Matches for quickope
tmux set -g @copytk-quickopen-match-0-0 urls
tmux set -g @copytk-quickopen-match-0-1 abspaths


fi

