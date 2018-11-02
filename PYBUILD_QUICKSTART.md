# Pybuild v2 (devel)

This version of pybuild gets out of your way and moves almost everything into a subdirectory. This helps avoid filename collisions and looks cleaner in your project. Remember that:

* Your build venv will not be checked in (unless you `git add -f xxx` but don't do that please)
* Things in your requirements.txt will can/should/will be added to your repository so long as you commit them

## What is the "bloat" in pybuild/packages ??

The packages directory contains the latest versions of pip, virtualenv and setuptools and works on any system with Python >= 2.6 (including 3.x)

```
$ du -hs pybuild/packages
18M	pybuild/packages
```

This is the bootstrapping piece. This makes it so that you don't need to rely on your system version of pip and virtualenv. While it is not difficult to install them, it is nice to have a fixed version. The packages directory is really the crux of pybuild. If 18MB is too big for your standards, you are SOL, don't use pybuild. But keep in mind it only changes occasionally when either `setuptools`, `pip` or `virtualenv` release updated versions and I take the few moments to update it. Note that you will never need to commit this directory, it is added already and does not change regardless of what you change in your project. It is purely for bootstrapping conveniently on *any* machine

## How to deploy with the new pybuild structure

As before, you may simple type:

* `make -f pybuild.mk` - To build a python2 virtual environment
* `make -f pybuild.mk python3` - To deploy a python3 virtual environment
* `make -f pybuild.mk new REPO=ssh://github.com/myname/myproject` - To "install" pybuild into an existing (preferably empty) project
* `make -f pybuild.mk clean` - To clean out a deployed virtual environment
* `make -f pybuild.mk rebuild` - Shortcut for make clean && make
* `source activate` - Shortcut for `source pybuild/venv/bin/activate`

## New things

* `./edit-requirements` - Simple script to invoke `$EDITOR pybuild/venv/requirements.txt`

## Customizing

If your project doesn't have a `Makefile`, feel free to `mv pybuild.mk Makefile` or `ln -sf pybuild.mk Makefile`. Doing this will remove the requirement to specify `-f pybuild.mk` for each usage of `make`. It is renamed to `pybuild.mk` only to avoid colliding with files in your project

## Common Mistakes / Errors That Are Not Obvious to Fix

* First perform a `make -f pybuild.mk clean` and then try a `make -f pybuild.mk` in case the virtualenv got into some weird state.
* If that doesn't help, you may need to edit the pybuild.mk file and/or `pybuild` to "correct" the path to your system Python. This is often necessary on MacOS, a semi-supported platform.

## Assumptions made by `pybuild` and `pybuild.mk`

* `python2` exists in `/usr/bin/python2`
* `python3` exists in `/usr/bin/python3`

MacOS users, and users of other systems such as old versions of Solaris, AIX, etc. may have to change this if they have nonstandard install locations. Do *not* change it to point to `python` in another virtual environment. Use your "system" Python.

## Changes from pybuild23 v1

The user experience should be the same, except the packages and venv directories have been nested one directory to get out of your projects way. The only difference is you will need to edit pybuild/etc/pip.ini and pybuild/venv/requirements.txt to suit your needs. There are shortcut scripts to do this in the root directory. In prior versions, `etc/`, `venv/`, and `Makefile` were in the root of the project, which worked but could clash with your project. Also, some people found it ugly to have these files in the root of their project.

## Release notes

There should be some bugs, please report them via github issues. PRs welcome. If I do not respond to them, please use `@mzpqnxow` to get my attention :>

## Copyright

(C) 2018 AG/DM
See the [LICENSE file](pybuild/LICENSE.md)


