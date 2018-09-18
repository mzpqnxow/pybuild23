#!/bin/sh
if [ -z $EDITOR ]; then
  EDITOR=vi
else

$EDITOR pybuild/venv/requirements.txt
