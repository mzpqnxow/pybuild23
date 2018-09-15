[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

# pybuild23
Streamline Python venv creation w/Python 2.6, 2.7 and 3.x using a simple make command. Common dependencies (pip, virtualenv, setuptools) included!

## Basic usage

Just run `make` or `make python2` for a Python 2 virtual environment, use `make python3` for a Python 3 virtual environment. Once the environment is built, use `source venv/bin/activate` and `deactivate` as usual

## Advanced usage

Use to add a pybuild skeleton into a new (blank) repository:

```
$ make new REPO=ssh://github.com/you/new_empty_project
```

## Adding your own dependencies

Place your dependencies in venv/requirements.txt. These will be added when `make` runs

## Credits

* Concept and original implementation by David Marker
* Re-implementation, Python3 support, `make new` target by Adam Greene. See LICENSE.
