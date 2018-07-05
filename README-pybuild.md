## How to deploy with the new pybuild structure

As before, you may simple type:

* `make` - To build a python2 virtual environment
* `make python3` - To deploy a python3 virtual environment
* `make new REPO=ssh://github.com/myname/myproject` - To "install" pybuild into an existing (preferably empty) project
* `make clean` - To clean out a deployed virtual environment
* `make rebuild` - Shortcut for make clean && make
* `source activate` - Shortcut for `source pybuild/venv/bin/activate`

## Changes

The experience should be the same. The only difference is you will need to edit pybuild/etc/pip.ini and pybuild/venv/requirements.txt to suit your needs. In prior versions, etc/ and venv/ were in the root of the project

## Release notes

This is a development build and should be considered beta/test as it completely changes the filesystem layout. This was done to minimize file collisions and eliminate "clutter" in the root of your project, and otherwise abstract the existence of pybuild. There should be some bugs, please report them via github issues. Thanks


