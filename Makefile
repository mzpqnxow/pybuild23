#
# Universal pybuild for Python2 and Python3 on Linux
# MacOS works, with some tweaks (use PYTHON=/path/to/system/python)
# Supported Targets:
#  - all: Default target, build a python2 virtual environment in venv/
#         Customize and commit venv/requirements.txt to your repo
#         Activate as usual with source venv/bin/activate
#  - python2: Same as `all` target
#  - python3: Same as python2, except builds a python3 virtual environment
#  - venv: Create a missing venv/ dir, you shouldn't ever need this
#  - clean: Clean up the virtual environment without touching your code
#           Everything in venv/ will be deleted except requirements.txt
#  - rebuild: Equivalent to make clean && make
#  - publish: Publishes a package based on the contents of your ~/.pypirc
#             file
#  - pypirc: Dynamically/interactively creates a ~/.pypirc configured for
#            user with Artifactory. Only needed once on any given
#            system, not per project, since pypirc is global to the user
#            and not respected by virtualenv
#  - expert: Remove docs in the root directory not required for deployment
#            such as readme markdown files. You will have to manually commit
#            after this
#
# Remember that PYTHON and PYTHON3 can be overridden on the command line
# using `make PYTHON=/opt/my/python`. The same is true of the VENV_DIR
# but there's really no reason to change the venv dir IMO.
#
# How does this work? This is all from pybuild, an old project of mine
# and a friend, @ github.com/mzpqnxow/pybuild23
#
# - AG, 2018
#
ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON = /usr/bin/python
PYTHON3 = /usr/bin/python3
VENV_DIR = venv/
RM_RF := /bin/rm -rf
PYBUILD := ./pybuild
BUILD_FILES := build dist *.egg-info
PROJECT_FILES := etc packages pybuild .gitignore Makefile
COPY_FILES := etc packages pybuild Makefile venv
PACKAGES := packages
SYMLINKS := pip virtualenv easy_install
BEGINNER_FILES := LICENSE LICENSE.md PYBUILD_README.md QUICKSTART.md TODO.md edit-requirements.sh
PYPIRC := $(ROOT_DIR)/.pypirc.template
CC = gcc  # An optional dependency, really. It depends on what packages you need
TWINE = twine
# Note, twine is a publish-time dependency. It should be in your
# venv/requirements.txt already, you shouldn't remove it
DEPENDENCIES = rm git cp mv mktemp dirname realpath
REQUIREMENTS_TXT := $(ROOT_DIR)/venv/requirements.txt

# If requirements.txt gets hosed, build a new, sane one
define REQUIREMENTS_TXT_CONTENT
# Many of these packages pull in other linters and static analysis tools
# as well, so check venv/bin after you build and see what's there. These
# are mostly small modules and only add 30 seconds or so to your virtual
#environment build time. But you're free to remove them of course
# --- Begin suggested / default venv packages ---
flake8				            # Wraps pyflakes, pycodestyle and mccabe
pylint                          # linters..
pylama                          # linter..
isort                           # cleans up imports, configurable
seed-isort-config               #  an isort companion
bandit                          # Static analysis for security issues
pyt                             # Static analysis for security issues, specifically webaoos
pydocstyle                      # Keep you on track with documentation style, per pydoc specs
ipython                         # This will slow your build and bloat your venv, but it's nice to have
setuptools\n\
wheel\n\
twine                           # The new way to publish to a PyPi repository
# --- End suggested / default venv packages ---

# --- Begin your own requirements ---
endef
export REQUIREMENTS_TXT_CONTENT

define PYPIRC_MESSAGE
-------- Credentialed PyPirc Installation --------

Follow the prompts to install a ~/.pypirc file that allows you to publish to an Artifactory PyPi
WARN: This is a global configuration file for your username
NOTICE: Any existing ~/.pypirc will be backed up in ~/.pypirc.bak.*
-------- PyPirc Crdentials --------

Please enter your credentials and a PyPirc file will be created
SECURITY: The file will be stored mode 0600 in ~/.pypirc, private from other users

endef
export PYPIRC_MESSAGE

define PROJECT_HELP_MSG
PyBuild23 - https://github.com/mzpqnxow/pybuild23

    Automatically deploy Python Virtual Environments for production applications without any
    system or local user dependencies (i.e. pip, virtualenv, setuptools)

    All dependencies to bootstrap a virtualenv are included so there is no need to use get-pip.py
    or to use your system package manager to install pip or virtualenv

    For deployment, use the python2, python3, clean and/or rebuild targets. Other less common
    targets are documented below

    Command / Target | Action
    -----------------|----------------------------------------------------------
    make python2     | Create a Python 2.6 or 2.7 based virtual environment
    make python3     | Create a Python 3.x based virtual environment
    make clean       | Clean the current virtual environment
    make rebuild     | Clean and rebuild a 2.6 or 2.7 based virtual environment
    make new         | Add pybuild23 into an existing (preferably empty) git project using REPO=protocol://project.uri
    make pypirc      | Create a basic ~/.pypirc file from a template
    make release     | Publish a package with version autobump **only when using versioneer and setuptools**
    ...              | Read Makefile or documentation for more targets
 
    Edit venv/requirements.txt and commit to set virtual environment dependencies
    Edit etc/pip.ini for a custom environment (if using Artifactory or other special PyPi server)
    Use the release target if using git and versioneer and with a configured ~/.pypirc

    --- QUICK START: SET REQUIREMENTS FOR YOUR PROJECT ---
      $$ vim venv/requirements.txt

    --- QUICK START: DEPLOYMENT ---
      $$ make (python2|python3)
      $$ source venv/bin/activate

    --- QUICK START: SOURCE CONTROL ---
      $$ git add . && git commit -m 'Add pybuild23 base' .
      NOTE: The .gitignore file will ensure only the required pybuild23 files are checked in (~15MB)

endef
export PROJECT_HELP_MSG

K := $(foreach exec,$(DEPENDENCIES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH")))

export PROJECT_HELP_MSG

all:
	@echo "$$PROJECT_HELP_MSG"

requirements: $(REQUIREMENTS_TXT)

python2: $(VENV_DIR) clean
	@echo "Executing pybuild (`basename $(PYBUILD)` -p $(PYTHON) $(VENV_DIR))"
	@$(PYBUILD) -p $(PYTHON) $(VENV_DIR)

python3: $(VENV_DIR) clean
	@echo "Executing pybuild (`basename $(PYBUILD)` -p $(PYTHON3) $(VENV_DIR))"
	@$(PYBUILD) -p $(PYTHON3) --python3 $(VENV_DIR)

$(REQUIREMENTS_TXT): $(VENV_DIR)
	@echo $(REQUIREMENTS_TXT_CONTENT) > $(REQUIREMENTS_TXT)

$(VENV_DIR):
	@echo 'WARN'; \
	echo 'WARN: VENV_DIR is missing, making directory\nWARN'; \
	mkdir -p $(VENV_DIR)


#
# This target is meant for use with versioneer only!!
# To install versioneer, see https://github.com/warner/python-versioneer
# It is very simple to install, use pep440. Once configured, you can
# use this target and greatly simplify publishing to PyPi or Artifactory!!
#
# By default, make release will:
#  - tag your current branch
#      $ make release bump=major
#      $ make release bump=minor
#      $ make release
#  - Publish your Python package to your PyPi repository with the new tag
#  - Perform a git push on any committed changes you have
#  - Perform a git push --tags to add the new tag to git
#
release:
	$(eval v := $(shell git describe --tags --abbrev=0 | sed -Ee 's/^v|-.*//'))
ifeq ($(bump), major)
	$(eval f := 1)
else ifeq ($(bump), minor)
	$(eval f := 2)
else
	$(eval f := 3)
endif
	git tag -a `echo $(v) | awk -F. -v OFS=. -v f=$(f) '{ $$f++ } 1'` && \
    python setup.py sdist || (rm -rf dist/ ;  echo Failed to build sdist ; /bin/false)
	$(TWINE) upload -r local dist/* --verbose || rm -rf $(BUILD_FILES)
	rm -rf $(BUILD_FILES)
	git commit -am "Bumped to version `echo $(v) | awk -F. -v OFS=. -v f=$(f) '{ $$f++ } 1'`" || /bin/true
	git push --tags

publish: $(PIP_CONF)
	$(PYTHON) setup.py sdist upload -r local
	$(TWINE) upload -r local dist/* --verbose || rm -rf $(BUILD_FILES)


push: publish

freeze:
	$(PYBUILD) --freeze $(VENV_DIR) \
          && echo '' && \
          echo "Froze virtual environment requirements in venv/:" && \
          echo `ls -lr $(VENV_DIR)/codefreeze-* | tail -1` && \
          git add -f `ls -lr $(VENV_DIR)/codefreeze-* | tail -1 | awk '{print $$9}'`

pypirc:
	@echo "$$PYPIRC_MESSAGE"
	@if [ -e "~/.pypirc" ]; then cp -f ~/.pypirc ~/.pypirc.bak.$(date +%s) 2>/dev/null || /bin/true; fi 
	@echo -n 'Please enter username: ' && \
	read user && \
	echo -n 'Please enter password (will not be printed to screen): ' && \
	stty -echo && \
	read pass && \
	stty echo && \
	sed \
          -e "s/%%USER%%/$$user/" \
          -e "s/%%PASS%%/$$pass/" \
          $(PYPIRC) > ~/.pypirc && \
          chmod 600 ~/.pypirc && \
          echo "Installation complete, `make publish` should now work for you" 

new:
	set -e; \
       	cd $(ROOT_DIR) && \
         export REPO_STRIPPED=$$(echo $(REPO) | sed -e 's|\.git||') && \
         export REPO_BASENAME=$$(basename $$REPO_STRIPPED) && \
         git clone $$REPO_STRIPPED && \
         pwd && \
         cp -r $(PROJECT_FILES) $$REPO_BASENAME/ && \
         export REPO_VENV=$$REPO_BASENAME/$(VENV_DIR) && \
         mkdir -p $$REPO_VENV && \
         cp $(VENV_DIR)/requirements.txt $$REPO_VENV && \
         mv $$REPO_BASENAME ../ ; x=$$PWD; cd ../$$REPO_BASENAME; \
         git add . && \
         git commit -m "Installing pybuild environment" . && \
         git push && \
         cd $$x ; \
         echo ; \
         echo "pybuild: Completed, project $$REPO_BASENAME now has pybuild skeleton checked in !!" \
         echo ; \
         echo "Use to following to work on your new project:" && \
         echo ; \
         echo "    $ cd ../$$REPO_BASENAME" && \
         echo "    $ git log" && \
         echo

clean:
	@TMPDIR=`mktemp -d` && \
	  cp -f venv/*requirements*.txt $$TMPDIR/ 2>/dev/null || \
	  ( \
	  	echo 'WARN\nWARN: requirements.txt is missing, rebuilding with boilerplate requirements.txt\nWARN'; \
	  	echo "$$REQUIREMENTS_TXT_CONTENT" > $(REQUIREMENTS_TXT) \
	  ) && \
	  cp -f venv/*requirements*.txt $$TMPDIR/ ; \
	  rm -rf $(VENV_DIR) && \
      mkdir $(VENV_DIR) && \
      mv $$TMPDIR/*requirements*.txt $(VENV_DIR)/ && \
      rm -f $(PACKAGES)/{$(SYMLINKS)} && \
      rm -rf $(BUILD_FILES) && \
      rm -rf $$TMPDIR

expert:
	@git rm --ignore-unmatch -f $(BEGINNER_FILES) || /bin/true
	@echo Removed non-critical docs files, commit now to persist changes in your repo
	@echo

distclean:
	@rm -rf $(BUILD_FILES)

rebuild: clean all

.PHONY:	python2 python3 rebuild clean pypirc publish distclean freeze
