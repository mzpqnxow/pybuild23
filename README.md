# pybuild23
Streamline Python venv creation w/Python 2.6, 2.7 and 3.x with a script and dependencies including setuptools, virtualenv, pip, etc

## Basic usage

Just run `make` or `make python2` for a Python 2 virtual environment, use `make python3` for a Python 3 virtual environment

## Advanced usage

Use to add a pybuild skeleton into a new (blank) repository:

```
$ make new REPO=ssh://github.com/you/new_empty_project
```

## Adding your own dependencies

Place your dependencies in venv/requirements.txt. These will be added when `make` runs

## Credits

Concept and implementation originally by David Marker, Python 3 support and `make new` target added by Adam Greene. See LICENSE.
