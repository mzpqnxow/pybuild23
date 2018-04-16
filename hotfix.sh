#!/bin/bash
#
# Fix for issue caused by pip10 upgrade
# Run this script while in any pybuil23 based project
# directory to fix
#
git clone https://github.com/mzpqnxow/pybuild23 && \
  cp pybuild23/pybuild pybuild && \
  rm -rf packages && \
  cp -r pybuild23/packages . && \
  rm -rf pybuild23 &&
  git add packages &&
  git commit -m 'Hotfix for pybuil23' pybuild packages
