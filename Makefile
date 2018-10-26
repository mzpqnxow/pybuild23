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
PYPIRC := $(ROOT_DIR)/.pypirc.template
CC := $(shell which gcc)
TWINE = $(shell which twine)
DEPENDENCIES = twine rm git cp mv mktemp dirname realpath
REQUIREMENTS_TXT := $(ROOT_DIR)/venv/requirements.txt
# If requirements.txt gets hosed, build a new, sane one
REQUIREMENTS_TXT_CONTENT := "\
\# Many of these packages pull in other linters and static analysis tools\n\
\# as well, so check venv/bin after you build and see what's there. These\n\
\# are mostly small modules and only add 30 seconds or so to your virtual\n\
\#environment build time. But you're free to remove them of course.\n\
\# --- Begin suggested / "default" venv packages ---\n\
flake8				            \# Wraps pyflakes, pycodestyle and mccabe\n\
pylint                          \# linters..\n\
pylama                          \# linter..\n\
isort                           \# cleans up imports, configurable\n\
seed-isort-config               \#  an isort companion\n\
bandit                          \# Static analysis for security issues\n\
pyt                             \# Static analysis for security issues, specifically webaoos\n\
pydocstyle                      \# Keep you on track with documentation style, per pydoc specs\n\
ipython                         \# This will slow your build and bloat your venv, but it's nice to have\n\
setuptools\n\
wheel\n\
twine                           \# The "new" way to publish to a PyPi repository\n\
\# --- End suggested / "default" venv packages ---\n\
\n\
\# --- Begin your own requirements ---\n\
"

K := $(foreach exec,$(DEPENDENCIES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH)))

all:
	@echo '----------|'
	@echo 'PyBuild23 |'
	@echo '------------------------------------------------------------------------'	
	@echo 'Please use a target such as python2, python3, new, clean, pypirc, etc ..'	
	@echo '------------------------------------------------------------------------'
	@echo 'python2   | Create a Python 2.6 or 2.7 based virtual environment'
	@echo 'python3   | Create a Python 3.x based virtual environment'
	@echo 'clean     | Clean the current virtual environment'
	@echo 'rebuild   | Clean and rebuild a 2.6 or 2.7 based virtual environment'
	@echo 'new       | Add pybuild23 into an existing (preferably empty) git project using REPO=protocol://project.uri'
	@echo 'pypirc    | Create a basic ~/.pypirc file from a template'
	@echo 'release   | Publish a package when using versioneer and setuptools (autobump)'	
	@echo '...       | Read Makefile or documentation for more targets'
	@echo '------------------------------------------------------------------------'
	@echo 
	@echo '** Edit venv/requirements.txt and commit to set virtual environment dependencies' 
	@echo '** Edit etc/pip.ini for a custom environment (if using Artifactory or other "special" PyPi server)'
	@echo '** Use the "release" target if using git and versioneer and with a configured ~/.pypirc' 
	@echo 

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
	@echo "----"
	@echo "WARN: VENV_DIR does not exist, creating it with no requirements.txt"
	@echo "----"
	@mkdir -p $(VENV_DIR)
	@echo <<"EOF" \


#
# This target is meant for use with versioneer !!
# To install versioneer, see the github.com page
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
	@echo '-------- Credentialed PyPirc Installation --------'
	@echo ''
	@echo 'Follow the prompts to install a ~/.pypirc file that allows you to publish to an Artifactory PyPi'
	@echo 'WARN: This is a global configuration file for your username ($$USER)'
	@echo 'NOTICE: Any existing ~/.pypirc will be backed up in ~/.pypirc.bak.*'
	@echo '-------- PyPirc Crdentials --------'
	@echo
	@echo 'Please enter your credentials and a PyPirc file will be created'
	@echo 'SECURITY: The file will be stored mode 0600 in ~/.pypirc, private from other users :>'
	@echo
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
	  cp venv/*requirements*.txt $$TMPDIR/ && \
          rm -rf $(VENV_DIR) && \
          mkdir $(VENV_DIR) && \
          mv $$TMPDIR/*requirements*.txt $(VENV_DIR)/ && \
          rm -f $(PACKAGES)/{$(SYMLINKS)} && \
          rm -rf $(BUILD_FILES) && \
          rm -rf $$TMPDIR

distclean:
	@rm -rf $(BUILD_FILES)

rebuild: clean all

.PHONY:	python2 python3 rebuild clean pypirc publish distclean freeze
