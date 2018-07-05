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

"""Localization."""

# Python 3 compatibility
from __future__ import (absolute_import, division, print_function,
                        unicode_literals)

# import io  # Python 3 compatibility
import locale
import sys

# from builtins import input  # Python 3 compatibility


def sys_lang():
    """Get system language."""
    lang = locale.getdefaultlocale()
    # lang = 'EN'  # only for testing
    if 'pt_' in lang[0]:  # Portuguese
        return 'PT'
    else:  # English
        return 'EN'

LANG = sys_lang()

FS_ENC = sys.getfilesystemencoding()
INPUT_ENC = sys.stdin.encoding
UTF_ENC = 'utf-8'

if LANG == 'PT':  # Portuguese
    BANNER = ' não tem QUALQUER GARANTIA. É software livre e você está ' + \
             'autorizado a redistribui-lo dentro de certas condições.'
    FILE_NOT_FOUND = 'Erro: ficheiro não encontrado -'
    Q_APP_AUTHOR = 'Nome do autor? '
    Q_APP_EMAIL = 'E-mail? '
    Q_APP_KEYWORDS = 'Palavras-chave? '
    Q_APP_LICENSE = 'Licença? '
    Q_APP_NAME = 'Nome da aplicação? '
    Q_APP_URL = 'URL? '
    Q_APP_VERSION = 'Versão? '
    REMINDERS = """
*** ATENÇÃO - A FAZER ***
1. Editar appinfo.py para atualizar as categorias do PyPI.
2. Editar requirements.txt para atualizar os requisitos da sua aplicação.
3. Editar requirements-dev.txt para atualizar os requisitos de desenvolvimento.
   Para os instalar, execute
   pip install -r requirements-dev.txt
4. Se pretende criar documentação, deverá executar
   sphinx-quickstart
   e depois
   easysetup -d
   Quando executar o sphinx-quickstart deverá responder às questões de acordo
   com o indicado abaixo (todas as outras deve aceitar o valor por omissão):
   Root path for the documentation [.]: doc
   Project name: a
   Author name(s): a
   Project version: 1
   autodoc: automatically insert docstrings from modules (y/n) [n]: y
   doctest: automatically test code snippets in doctest blocks (y/n) [n]: y
   coverage: checks for documentation coverage (y/n) [n]: y
   viewcode: include links to the source code ... Python objects (y/n) [n]: y
5. A qualquer momento, para criar um ficheiro reference.rst atualizado no
   diretório doc, execute
   easysetup -r
    """
    VERSION = 'Versão'
    VERSION_WITH_SPACES = ' versão '
    WRONG_ARG = 'Erro: argumento incorreto '
else:  # English
    BANNER = ' comes with ABSOLUTELY NO WARRANTY. This is free software, ' + \
             'and you are welcome to redistribute it under certain conditions.'
    FILE_NOT_FOUND = 'Error: file not found -'
    Q_APP_AUTHOR = 'Author name? '
    Q_APP_EMAIL = 'E-mail? '
    Q_APP_KEYWORDS = 'Keywords? '
    Q_APP_LICENSE = 'License? '
    Q_APP_NAME = 'Application name? '
    Q_APP_URL = 'URL? '
    Q_APP_VERSION = 'Version? '
    REMINDERS = """
*** ATTENTION - TODO ***
1. Edit appinfo.py to update PyPI classifiers.
2. Edit requirements.txt to update your application requirements.
3. Edit requirements-dev.txt to update your development requirements.
   To install them, execute
   pip install -r requirements-dev.txt
4. If you want to create documentation, you should execute
   sphinx-quickstart
   and then
   easysetup -d
   When you execute sphinx-quickstart you should reply to the questions as
   shown below (all others you should accept the default):
   Root path for the documentation [.]: doc
   Project name: a
   Author name(s): a
   Project version: 1
   autodoc: automatically insert docstrings from modules (y/n) [n]: y
   doctest: automatically test code snippets in doctest blocks (y/n) [n]: y
   coverage: checks for documentation coverage (y/n) [n]: y
   viewcode: include links to the source code ... Python objects (y/n) [n]: y
5. At any time, to create an updated reference.rst file in the doc directory,
   execute
   easysetup -r
    """
    VERSION = 'Version'
    VERSION_WITH_SPACES = ' version '
    WRONG_ARG = 'Error: incorrect argument '


if __name__ == '__main__':
    # import doctest
    # doctest.testmod(verbose=True)
    pass
