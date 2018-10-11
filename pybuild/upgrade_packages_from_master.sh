#!/bin/bash
#
# Fix for issue caused by pip10 upgrade
# Run this script while in any pybuil23 based project
# directory to fix
#

function die() {
  echo "$1"
  echo "Exiting ..."
  exit 1
}
[[ -d .git ]] || die "Current directory is not a git repo"
[[ -f pybuild ]] || die "Project has no pybuild file"
[[ -d pybuild23 ]] && die "Project has pybuild23 in root, this is not right"

git clone https://github.com/mzpqnxow/pybuild23 && \
  cp pybuild23/pybuild pybuild && \
  rm -rf packages && \
  cp -r pybuild23/packages . && \
  rm -rf pybuild23 &&
  git add packages &&
  git commit -m 'Updated pybuild packages !! ...' pybuild packages
