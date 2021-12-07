#!/bin/bash

success () {
    # Bold green
    printf "\e[32;1m%s\e[0m\033[0m\n" "[👌☕️ SUCCESS]: $1"
}

error () {
    # Bold red
    printf "\e[31;1m%s\e[0m\033[0m\n" "[⛔️ ERROR]: $1"
}

warn () {
    # Bold orange/brown
    printf "\e[33;1m%s\e[0m\033[0m\n" "[⚠️ WARN]: $1"
}

i () {
    # Bold light blue
    printf "\e[34;1m%s\e[1m\033[0m\n" "[📚 INFO]: $1"
}

export -f success;
export -f error;
export -f i;