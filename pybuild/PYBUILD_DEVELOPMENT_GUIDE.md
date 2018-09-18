# What is pybuild

Pybuild is really just a minimalist set of packages required to boot a virtual environment, installing packages from a requirements.txt file. To accomplish this, it includes the `virtualenv`, `pip`, and `setuptools` packages. Beyond that, it is a simple Python script that uses environment variables to invoke the bundled versions of `pip` and `virtualenv`, which can be found in `packages/`

## How to upgrade pybuild packages

It is important that you do not *overwrite* the packages directory in-place as stale files may remain and cause problems. But before we get that far, let's create the packages directory in a safe place first.

First, make sure you don't already have a `~/.local` directory- you very well may. If you do, temporarily move it to ~/.local.bak. As your first step, you will be building a user-packages installation using the latest version of pip. This is quite simple, but you of course must have the version of Python that you are targeting support for on your system. Check for python2 and python3 if you're not sure:

```$ which python2
/usr/bin/python2
$which python3
/usr/bin/python3
$```

Looks good. Let's get started.

### Build a segregated Python2 package tree with the bare essentials (`pip`, `virtualenv`, `setuptools`)

You only need the above 3 packages since when a user does `make`, `pip` will install everything after the virtual environment is created, using the user's `venv/requirements.txt` file. **DO NOT DO THIS AS ROOT**

```$ wget https://bootstrap.pypa.io/get-pip.py
$ python2 get-pip.py --user
$ ls  ~/.local/{lib,bin,lib/python2.7/site-packages/}
/home/user/.local/bin:
pip  pip2  pip2.7

/home/user/.local/lib:
python2.7

/home/capam-meta-svc/.local/lib/python2.7/site-packages/:
pip  pip-18.0.dist-info
$ python2 ~/.local/bin/pip2 install --user virtualenv setuptools
...
$ ls  ~/.local/{lib,bin,lib/python2.7/site-packages/} | sed -e 's/capam-meta-svc/user/'
/home/user/.local/bin:
pip
pip2
pip2.7
virtualenv

/home/user/.local/lib:
python2.7

/home/user/.local/lib/python2.7/site-packages/:
pip
pip-18.0.dist-info
virtualenv-16.0.0.dist-info
virtualenv.py
virtualenv.pyc
virtualenv_support
$
```

... to be continued, too busy ....
