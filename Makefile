#
# Universal pybuild @ Jet Makefile
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
#            user with Jet Artifactory. Only needed once on any given
#            system, not per project, since pypirc is global to the user
#            and not respected by virtualenv
#
# Remember that PYTHON and PYTHON3 can be overridden on the command line
# using `make PYTHON=/opt/my/python`. The same is true of the VENV_DIR
# but there's really no reason to change the venv dir IMO.
#
# How does this work? This is all from pybuild, an old project of mine
# and a friend, @ github.com/mzpqnxow/pybuild23. It is public and free
# but copyrighted by me. It was not developed on Jet time and actually
# predates Jet by quite a bit, though the repository has been created
# and destroyed several times over the last few years
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
PROJECT_FILES := etc packages pybuild .gitignore examples/Makefile
COPY_FILES := etc packages pybuild examples/Makefile venv
PACKAGES := packages
SYMLINKS := pip twine virtualenv pkginfo easy_install
PYPIRC := $(ROOT_DIR)/pypirc.template
CC := gcc

all: python2

python2: $(VENV_DIR)
	@echo "Executing pybuild (`basename $(PYBUILD)` -p $(PYTHON) $(VENV_DIR))"
	@$(PYBUILD) -p $(PYTHON) $(VENV_DIR)

python3: $(VENV_DIR)
	@echo "Executing pybuild (`basename $(PYBUILD)` -p $(PYTHON3) $(VENV_DIR))"
	@$(PYBUILD) -p $(PYTHON3) --python3 $(VENV_DIR)

$(VENV_DIR):
	@echo "----"
	@echo "WARN: VENV_DIR does not exist, creating it with no requirements"
	@echo "----"
	@mkdir -p $(VENV_DIR)

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
	git tag `echo $(v) | awk -F. -v OFS=. -v f=$(f) '{ $$f++ } 1'`
	python setup.py sdist upload -r local
	git commit -am "Bumped to version `echo $(v) | awk -F. -v OFS=. -v f=$(f) '{ $$f++ } 1'`"
	git push
	git push --tags

publish:
	git push
#	python setup.py sdist upload -r local
#	git push && python setup.py sdist upload -r local
#	make clean

push: publish

freeze:
	$(PYBUILD) --freeze $(VENV_DIR) && ls -lr $(VENV_DIR)/

pypirc:
	@echo '-------- Jet PyPirc Installation --------'
	echo ''
	echo 'Follow the prompts to install a ~/.pypirc file that allows you to publish to Jet Artifactory'
	echo 'WARN: This is a global configuration file for your username ($$USER)'
	echo 'NOTICE: Any existing ~/.pypirc will be backed up in ~/.pypirc.bak.*'
	echo '-------- Jet PyPirc Crdentials --------'
	echo 'Please enter your credentials and a PyPirc file will be created'
	echo 'SECURITY: The file will be stored mode 0600 in ~/.pypirc, private from other users :>'
	echo
	cp ~/.pypirc ~/.pypirc.bak.$(date +%s) && \
	echo -n 'Please enter JET.local username (without @jet.com): ' && \
	read user && \
	echo -n 'Please enter JET.local password: ' && \
	read pass && \
	sed \
          -e "s/%%USER%%/$$user/" \
          -e "s/%%PASS%%/$$pass/" \
          $(PYPIRC) > ~/.pypirc && \
          chmod 600 ~/.pypirc && \
          echo "Installation complete, `make publish` should now work for you" 


clean:
	TMPDIR=`mktemp -d` && \
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

.PHONY:	python2 python3 rebuild clean pypirc publish
