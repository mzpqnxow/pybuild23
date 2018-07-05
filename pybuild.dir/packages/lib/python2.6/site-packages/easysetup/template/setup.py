#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright 2009-2015 Joao Carlos Roseta Matos
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""Setup for source, egg, wheel, wininst, msi and dumb distributions."""

# Python 3 compatibility
from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

import io  # Python 3 compatibility
import os

# from builtins import input  # Python 3 compatibility
from setuptools import setup, find_packages

import appinfo


UTF_ENC = 'utf-8'

DESC = LONG_DESC = ''
if os.path.isfile(appinfo.README_FILE):
    with io.open(appinfo.README_FILE, encoding=UTF_ENC) as f_in:
        LONG_DESC = f_in.read()
        DESC = LONG_DESC.split('\n')[3]

# PACKAGES = [appinfo.APP_NAME]  # use only if find_packages() doesn't work

REQUIREMENTS = ''
if os.path.isfile(appinfo.REQUIREMENTS_FILE):
    with io.open(appinfo.REQUIREMENTS_FILE, encoding=UTF_ENC) as f_in:
        REQUIREMENTS = f_in.read().splitlines()

ENTRY_POINTS = {'console_scripts': [appinfo.APP_NAME + '=' +
                                    appinfo.APP_NAME + '.' +
                                    appinfo.APP_NAME + ':main'],
                # 'gui_scripts' : ['app_gui=' + appinfo.APP_NAME + '.' +
                #                  appinfo.APP_NAME + ':start']
                }

setup(name=appinfo.APP_NAME,
      version=appinfo.APP_VERSION,
      description=DESC,
      long_description=LONG_DESC,
      license=appinfo.APP_LICENSE,
      url=appinfo.APP_URL,
      author=appinfo.APP_AUTHOR,
      author_email=appinfo.APP_EMAIL,

      classifiers=appinfo.CLASSIFIERS,
      keywords=appinfo.APP_KEYWORDS,

      packages=find_packages(),
      # packages=setuptools.find_packages(exclude=['docs',
      #                                            'tests*']),

      # use only if find_packages() doesn't work
      # packages=PACKAGES,
      # package_dir={'': appinfo.APP_NAME},

      # to create an executable
      entry_points=ENTRY_POINTS,

      install_requires=REQUIREMENTS,

      # used only if the package is not in PyPI, but exists as an
      # egg, sdist format or as a single .py file
      # see http://goo.gl/OgnjhO
      # dependency_links = ['http://host.domain.local/dir/'],

      include_package_data=True,  # use MANIFEST.in during install
      )
