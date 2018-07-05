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

"""Helps creating a package distribution setup for Windows users."""

# Python 3 compatibility
from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

import datetime as dt
import glob
import io  # Python 3 compatibility
import os
import shutil as shu
import sys
import zipfile as zipf

from builtins import input  # Python 3 compatibility
import colorama as clrm

import common
import localization as lcl


DEFAULT_AUTHOR = 'CHANGE_ME'
DEFAULT_EMAIL = 'CHANGE_ME'
DEFAULT_URL = 'https://github.com/CHANGE_ME/'

DEFAULT_VERSION = '0.0.1'
DEFAULT_LICENSE = 'GNU General Public License v2 or later (GPLv2+)'

BAK_DIR = '_bak'
APPLICATION_TEMPLATE_FILE = '/APPLICATION_NAME.py'

app_name = ''
app_version = ''
app_license = ''
app_author = ''
app_email = ''
app_url = ''
app_keywords = ''
cur_date = str(dt.date.today())


def update_file(filename):
    """Update file with user input."""
    with io.open(filename, encoding=lcl.UTF_ENC) as f_in:
        text = f_in.readlines()

    new_text = ''
    changed = False
    for line in text:
        if 'APPLICATION_NAME' in line:
            line = line.replace('APPLICATION_NAME', app_name)
            changed = True
        if 'APPLICATION_VERSION' in line:
            line = line.replace('APPLICATION_VERSION', app_version)
            changed = True
        if 'APPLICATION_LICENSE' in line:
            line = line.replace('APPLICATION_LICENSE', app_license)
            changed = True
        if 'APPLICATION_AUTHOR' in line:
            line = line.replace('APPLICATION_AUTHOR', app_author)
            changed = True
        if 'APPLICATION_EMAIL' in line:
            line = line.replace('APPLICATION_EMAIL', app_email)
            changed = True
        if 'APPLICATION_URL' in line:
            line = line.replace('APPLICATION_URL', app_url)
            changed = True
        if 'APPLICATION_KEYWORDS' in line:
            line = line.replace('APPLICATION_KEYWORDS', app_keywords)
            changed = True
        if 'CUR_DATE' in line:
            line = line.replace('CUR_DATE', cur_date)
            changed = True
        # quick hacks
        if 'README.rst' in filename and '================' in line:
            line = line.replace('================', '=' * len(app_name))
            changed = True
        if 'reference.rst' in filename and '::::::::::::::::' in line:
            line = line.replace('::::::::::::::::', ':' * len(app_name))
            changed = True
        new_text += line
    if changed:
        with io.open(filename, 'w', encoding=lcl.UTF_ENC) as f_out:
            f_out.writelines(new_text)


def get_app_info():
    """Read application info from appinfo.py."""
    global app_name, app_version, app_license, app_author, app_email, \
        app_url, app_keywords

    with io.open(common.APP_INFO_FILENAME, encoding=lcl.UTF_ENC) as f_in:
        text = f_in.readlines()
    for line in text:
        if 'APP_NAME = ' in line:
            app_name = line.split("'")[1]
        if 'APP_VERSION = ' in line:
            app_version = line.split("'")[1]
        if 'APP_LICENSE = ' in line:
            app_license = line.split("'")[1]
        if 'APP_AUTHOR = ' in line:
            app_author = line.split("'")[1]
        if 'APP_EMAIL = ' in line:
            app_email = line.split("'")[1]
        if 'APP_URL = ' in line:
            app_url = line.split("'")[1]
        if 'APP_KEYWORDS = ' in line:
            app_keywords = line.split("'")[1]


def update_ref():
    """Creates a new doc/reference.rst for Sphinx autodoc extension."""
    filenames = glob.glob(app_name + '/*.py')
    # remove __init__.py
    filenames = [filename for filename in filenames
                 if '__init__.py' not in filename and
                 'appinfo.py' not in filename]

    if filenames:
        # remove paths
        filenames = [filename.split(os.sep)[-1] for filename in filenames]
        # remove extensions
        filenames = [filename.split('.')[0] for filename in filenames]

        text = 'Reference\n---------\n'

        for filename in filenames:
            text += '\n'
            text += filename + '\n' + ':' * len(filename) + '\n\n'
            text += '.. automodule:: ' + filename + '\n'
            text += '    :members:\n'

        with io.open('doc/reference.rst', 'w', encoding=lcl.UTF_ENC) as f_out:
            f_out.writelines(text)


def update_doc():
    """Update doc dir."""
    filenames = glob.glob(common.DATA_PATH + 'template/doc/*')
    # copy template/doc files
    for filename in filenames:
        # if file exists delete it
        if os.path.isfile('doc/' + filename.split(os.sep)[-1]):
            os.remove('doc/' + filename.split(os.sep)[-1])

        shu.copyfile(filename, 'doc/' + filename.split(os.sep)[-1])

    filenames_to_update = ['conf.py', 'reference.rst']

    # delete .pyc files and update files
    filenames = glob.glob('doc/*')
    for filename in filenames:
        if '.pyc' in filename:
            os.remove(filename)
        else:
            if filename.split(os.sep)[-1] in filenames_to_update:
                update_file(filename)

    update_ref()


def create_redir2rtd_zip():
    """Create zip of index.html that redirects pythonhosted to RTD."""
    filename = 'pythonhosted.org/index.html'
    with zipf.ZipFile('pythonhosted.org/redir2RTD.zip', 'w') as archive:
        archive.write(filename, filename.split('/')[-1])


def create_setup():
    """Copy files from template and update them with user input."""
    global app_name, app_version, app_license, app_author, app_email, \
        app_url, app_keywords, DEFAULT_AUTHOR, DEFAULT_EMAIL, \
        DEFAULT_LICENSE, DEFAULT_URL, DEFAULT_VERSION

    data_lst = common.load_data()
    if data_lst:
        (DEFAULT_AUTHOR, DEFAULT_EMAIL, DEFAULT_LICENSE, DEFAULT_URL,
         DEFAULT_VERSION) = data_lst

    while not app_name:
        app_name = input(lcl.Q_APP_NAME).decode(lcl.INPUT_ENC)

    app_version = input(lcl.Q_APP_VERSION + '[' + DEFAULT_VERSION +
                        '] ').decode(lcl.INPUT_ENC)
    if not app_version:
        app_version = DEFAULT_VERSION

    app_license = input(lcl.Q_APP_LICENSE + '[' + DEFAULT_LICENSE +
                        '] ').decode(lcl.INPUT_ENC)
    if not app_license:
        app_license = DEFAULT_LICENSE

    app_author = input(lcl.Q_APP_AUTHOR + '[' + DEFAULT_AUTHOR +
                       '] ').decode(lcl.INPUT_ENC)
    if not app_author:
        app_author = DEFAULT_AUTHOR

    app_email = input(lcl.Q_APP_EMAIL + '[' + DEFAULT_EMAIL +
                      '] ').decode(lcl.INPUT_ENC)
    if not app_email:
        app_email = DEFAULT_EMAIL

    app_url = input(lcl.Q_APP_URL + '[' + DEFAULT_URL +
                    '] ').decode(lcl.INPUT_ENC)
    if not app_url:
        app_url = DEFAULT_URL

    app_keywords = input(lcl.Q_APP_KEYWORDS).decode(lcl.INPUT_ENC)
    if not app_keywords:
        app_keywords = app_name

    data_lst = [app_author, app_email, app_license, app_url, app_version]
    common.save_data(data_lst)

    app_url += app_name

    # backup existing files
    backup = False
    filenames = glob.glob('*')
    filenames += glob.glob('.*')
    if filenames:
        backup = True
        os.mkdir(BAK_DIR)
        for filename in filenames:
            dest = BAK_DIR + '/' + filename.split(os.sep)[-1]
            shu.move(filename, dest)

    filenames = glob.glob(common.DATA_PATH + 'template/*')
    filenames += glob.glob(common.DATA_PATH + 'template/.*')
    # remove doc dir
    filenames = [filename for filename in filenames
                 if 'template' + os.sep + 'doc' not in filename]

    # copy files and dirs
    for filename in filenames:
        if os.path.isfile(filename):
            shu.copyfile(filename, filename.split(os.sep)[-1])
        else:
            shu.copytree(filename, filename.split(os.sep)[-1])

    common.sleep(2)

    os.rename('APPLICATION_NAME', app_name)  # rename application dir

    # collect all filenames, including from 1st level subdirs
    filenames = glob.glob('*')
    filenames = [filename for filename in filenames if BAK_DIR not in filename]
    filenames += glob.glob('.*')
    new_filenames = []
    for filename in filenames:
        if os.path.isdir(filename):
            new_filenames += glob.glob(filename + '/*')
    filenames += new_filenames

    exceptions = ['__init__.py', 'build.cmd', 'requirements.txt',
                  'requirements-dev.txt', 'setup.py', 'setup_py2exe.py',
                  'setup_utils.py']

    # delete .pyc files and update files
    for filename in filenames:
        if os.path.isfile(filename):
            if '.pyc' in filename:
                os.remove(filename)
            else:
                if filename.split(os.sep)[-1] not in exceptions:
                    update_file(filename)

    create_redir2rtd_zip()

    if backup:
        os.remove(app_name + APPLICATION_TEMPLATE_FILE)  # remove app template
        # restore files from backup, but only if they don't already exist
        filenames = glob.glob(BAK_DIR + '/*')
        for filename in filenames:
            dest = app_name + '/' + filename.split(os.sep)[-1]
            if not os.path.isfile(dest):
                shu.copyfile(filename, dest)
    else:
        os.rename(app_name + APPLICATION_TEMPLATE_FILE,
                  app_name + '/' + app_name + '.py')  # rename app template

    print(lcl.REMINDERS)


def main():
    """Process command line args."""
    clrm.init()

    args = sys.argv[1:]
    if args:
        args_set = set(args)

        max_args = 2  # -q and one other
        doc_arg_set = set(['-d', '--doc'])
        help_arg_set = set(['-h', '--help'])
        license_arg_set = set(['-l', '--license'])
        quiet_arg_set = set(['-q', '--quiet'])
        reference_arg_set = set(['-r', '--reference'])
        version_arg_set = set(['-V', '--version'])
        legal_args_set = (doc_arg_set | help_arg_set | license_arg_set |
                          quiet_arg_set | reference_arg_set | version_arg_set)

        # if any wrong arg, too many args or (max args and -q not among them)
        if (args_set - legal_args_set or len(args) > max_args or
           (len(args) == max_args and not (quiet_arg_set & args_set))):
            print(common.banner())
            print(clrm.Fore.RED + lcl.WRONG_ARG + '\n')
            print(clrm.Fore.RESET + common.usage())
        else:
            if not (quiet_arg_set & args_set):
                print(common.banner())

            if doc_arg_set & args_set:
                get_app_info()
                update_doc()
            elif license_arg_set & args_set:
                print(common.license_())
            elif help_arg_set & args_set:
                print(common.usage())
            elif reference_arg_set & args_set:
                get_app_info()
                update_ref()
            elif version_arg_set & args_set:
                print(lcl.VERSION, common.version())
            else:  # only -q
                create_setup()
    else:
        print(common.banner())
        create_setup()


if __name__ == '__main__':
    # import doctest
    # doctest.testmod(verbose=True)
    sys.exit(main())


# ToDo: Auto rebuild requirements.txt on each dist build.
# ToDo: CXF in Py2 and Py3
# ToDo: checks and error messages
# ToDo: Move build.cmd functionality to easysetup.py.
