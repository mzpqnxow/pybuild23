easysetup
=========

Helps creating a package distribution setup, that also runs tests, checkers and creates HTML and PDF documentation, for Windows users.

Description, features and To do
-------------------------------

**Description**

Helps creating a package distribution setup, that also runs tests and creates HTML and PDF documentation, for Windows users.

When running easysetup without options, everything on the current directory is moved to a _bak directory.

After running easysetup, you can find a build.cmd in the current directory that should be run to build your application (execute build -h to see usage options).

Before runnning build.cmd for the first time, you should execute 

.. code:: bash

    $ pip install -r requirements-dev.txt

to install it's requirements.

**Features:**

* Easy to use, just run easysetup from your application setup directory (it backups everything in current directory to _bak directory when run without options).
* Allows creating source, wheel, win (exe or msi), py2exe, egg, dumb (zip on windows, tar/ztar/gztar/zip on GNU Linux in the future) and rpm (on GNU Linux in the future) dists.
* All setup configuration is in one file (appinfo.py).
* Runs tests and creates HTML and PDF documentation (if you have them, of course).
* Can publish to PyPI (including documentation if exists) and PyPI tests.

* Creates index.html with redirection to RTD, to be used if preferred for hosting documentation.
* Creates templates for Travis, Shippable, AppVeyor and tox.
* Creates a template for development requirements.
* Creates a template for installation requirements.
* Creates a template for git VCS exceptions.
* Creates a template for files to be included in the setup.
* Creates a template for a README file.
* Creates a template for wheel setup and Sphinx documentation upload.
* Can create template files in the doc directory (assumes use of Sphinx and that the sphinx-quickstart command was already executed).
* Can create an updated reference.rst in the doc directory (assumes previous item with the autodoc extension).
* Updates usage section in README.rst based on usage.txt, if it exists inside your application directory.
* Saves answers (DEFAULT_AUTHOR, DEFAULT_EMAIL, DEFAULT_LICENSE, DEFAULT_URL and DEFAULT_VERSION) for future use in other applications.
* Recreates reference.rst in the doc directory on each build (can be disabled inside build.cmd by changing the REBUILD_REFERENCE=YES to other value).
* If the setup directory is empty then a main template file is created inside the application directory.
* Checks source code with flake8 and Py3 compatibility with pylint.
* Add URLs to README.rst for PyPI, PyPI documentation site and RTD.
* Collects all To do from py files into README.rst To do section.

**To do**

easysetup.py: Auto rebuild requirements.txt on each dist build.
easysetup.py: CXF in Py2 and Py3
easysetup.py: checks and error messages
easysetup.py: Move build.cmd functionality to easysetup.py.

Installation, usage and options
-------------------------------

**Installation**

.. code:: bash

    $ pip install easysetup

**Usage**

.. code:: bash

    $ easysetup

**Options**

.. code:: bash

    $ easysetup -h

    usage: easysetup [-option]

    optional arguments:
      -d, --doc             creates template files in the doc directory
      -h, --help            show this help message
      -l, --license         show license
      -q, --quiet           no banner
      -r, --reference       creates an updated reference.rst in the doc directory
      -V, --version         show version

    No arguments (or only -q, --quiet) creates setup files.
    easysetup should always be run from the application setup directory.

Resources and contributing
--------------------------

**Resources**

* `Repository PyPI <https://pypi.python.org/pypi/easysetup>`_
* `Documentation PyPI <http://pythonhosted.org/easysetup>`_
* `Repository Github <https://github.com/jcrmatos/easysetup>`_
* `Documentation Read the Docs <http://easysetup.readthedocs.org>`_

**Contributing**

If Other repository above is Github or compatible, follow these guidelines for contributing:

1. Fork the `repository`_ .
2. Make a branch of master and commit your changes to it.
3. Ensure that your name is added to the end of the AUTHORS.rst file using the format:
   ``Name <email@domain.com>``
4. Submit a Pull Request to the master branch.

.. _repository: https://github.com/jcrmatos/easysetup

Copyright 2009-2015 Joao Carlos Roseta Matos. Licensed under the GNU General Public License v2 or later (GPLv2+).


