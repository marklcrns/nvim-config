#!/bin/bash

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

ok() {
    echo -e "$COL_GREEN[ ok ]$COL_CYAN "$1
}

running() {
    echo -e "$COL_YELLOW ⇒ $COL_RESET "$1": "
}

action() {
    echo -e "\n$COL_YELLOW[ action ]:$COL_MAGENTA\n ⇒ $1..."
}

warn() {
    echo -e "$COL_YELLOW[ warning ]$COL_RESET "$1
}

error() {
    echo -e "$COL_RED[ error ]$COL_RESET "$1
}
