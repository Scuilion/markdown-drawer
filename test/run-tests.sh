#!/usr/bin/env bash

# Use privileged mode, to e.g. ignore $CDPATH.
set -p
GLOB=${1:-'*'}

cd "$( dirname "${BASH_SOURCE[0]}" )" || exit

: "${VADER_TEST_VIM:=vim}"
eval "$VADER_TEST_VIM -Nu vimrc -c 'Vader! $GLOB'"
