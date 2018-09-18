#!/bin/sh
if [ -z $EDITOR ]; then
  EDITOR=vi
fi

$EDITOR venv/requirements.txt
