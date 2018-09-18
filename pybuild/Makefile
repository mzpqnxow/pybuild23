#
# Universal pybuild @ Jet Makefile w/git tagging support. If using the
# versioneering package, no manual version bumping is required
#
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
#  - push: `git push`
#  - pypirc: Dynamically/interactively creates a ~/.pypirc configured for
#            user with Jet Artifactory. Only needed once on any given
#            system, not per project, since pypirc is global to the user
#            and not respected by virtualenv
#  - release: Use git tag to automatically increment the version number.
#             Next, use `python setup.py sdist upload` to publish to a
#             PyPi repository (i.e. Artifactory) and let versioneer set
#			  the versioning information into the dist automatically.
#			  Finally, push code and tags (but do NOT)
#	- freeze: Save the state of a deployed virtualenv, so it can be deployed
#			  in a repeatable way if necessary.
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
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON2 = `which python2`
PYTHON3 = `which python3`
PYTHON = $(PYTHON2)
RUNNING_USER = `whoami`
VENV_DIR = $(ROOT_DIR)/venv/
RM_RF := /bin/rm -rf
PYBUILD := ./pybuild
BUILD_FILES := build dist *.egg-info
PROJECT_FILES := etc packages pybuild .gitignore examples/Makefile
COPY_FILES := etc packages pybuild examples/Makefile venv
PACKAGES := packages
SYMLINKS := pip virtualenv easy_install
PYPIRC := $(ROOT_DIR)/pypirc.template
RELATIVE_ACTIVATE := pybuild/venv/bin/activate
BACK_RELATIVE_ACTIVATE := ../activate

CC := gcc

all: python2


python2: $(VENV_DIR) $(BACK_RELATIVE_ACTIVATE)
	@echo "Executing pybuild (`basename $(PYBUILD)` -p $(PYTHON) $(VENV_DIR))"
	@cd $(ROOT_DIR) && $(PYBUILD) -p $(PYTHON) $(VENV_DIR)
 
python3: $(VENV_DIR) $(BACK_RELATIVE_ACTIVATE)
	@echo "Executing pybuild (`basename $(PYBUILD)` -p $(PYTHON3) $(VENV_DIR))"
	@cd $(ROOT_DIR) && $(PYBUILD) -p $(PYTHON3) --python3 $(VENV_DIR)

$(BACK_RELATIVE_ACTIVATE):
	@cd $(ROOT_DIR) && ln -sf $(RELATIVE_ACTIVATE) $(BACK_RELATIVE_ACTIVATE)

$(VENV_DIR):
	@echo "----"
	@echo "WARN: VENV_DIR does not exist, creating it with no requirements"
	@echo "----"
	@mkdir -p $(VENV_DIR)

#
# Using versioneer to automate all of this, your current git tag will be
# incremented by the patch (1.0.0->1.0.1) if you just use `make release`
#
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
	git commit CHANGELOG.md -m "Bumped to version `echo $(v) | \
	  awk -F. -v OFS=. -v f=$(f) '{ $$f++ } 1'`"
	git push
	git push --tags

push:
	git push

freeze:
	$(PYBUILD) --freeze $(VENV_DIR) 

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

check_root:
	@[ $(RUNNING_USER) != "root" ] || (echo Disallowing clean as root user; /bin/false)


clean: check_root
	@cd $(ROOT_DIR) && TMPDIR=`mktemp -d` && \
	  cp venv/*requirements*.txt $$TMPDIR/ && \
          rm -rf $(VENV_DIR) && \
          mkdir $(VENV_DIR) && \
          mv $$TMPDIR/*requirements*.txt $(VENV_DIR)/ && \
          rm -f $(PACKAGES)/{$(SYMLINKS)} && \
          rm -rf $(BUILD_FILES) && \
          rm -rf $$TMPDIR && \
          rm -f $(BACK_RELATIVE_ACTIVATE)

rebuild: distclean python2

rebuild2: rebuild

rebuild3: distclean clean python3

distclean:
	@rm -rf $(BUILD_FILES)

rebuild: clean all

.PHONY:	python2 python3 rebuild rebuild2 rebuild3 clean pypirc release push distclean check_root
