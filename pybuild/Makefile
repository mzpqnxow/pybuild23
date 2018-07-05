#
# Makefile for pybuild23
#
# Usage:
#   $ make <-- will build for Python2 by default
#   $ make python2
#   $ make python3
#   $ make clean
#   $ make rebuild
#   $ make new REPO=https://github.com/someuser/someproject
#
# See the README.md for more details
#

ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON2 = `which python2`
PYTHON3 = `which python3`
PYTHON = $(PYTHON2)
RUNNING_USER = `whoami`
VENV_DIR = $(ROOT_DIR)/venv/
RM_RF := /bin/rm -rf
PYBUILD := ./pybuild
PROJECT_FILES := etc packages pybuild .gitignore examples/Makefile
COPY_FILES := etc packages pybuild examples/Makefile venv
RELATIVE_ACTIVATE := pybuild/venv/bin/activate
BACK_RELATIVE_ACTIVATE := ../activate

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

check_root:
	@[ $(RUNNING_USER) != "root" ] || (echo Disallowing clean as root user; /bin/false)

clean: check_root
	@cd $(ROOT_DIR) && TMPFILE=`mktemp` && \
	  cp venv/requirements.txt $$TMPFILE && \
          rm -rf $(VENV_DIR) && \
          mkdir $(VENV_DIR) && \
          mv $$TMPFILE $(VENV_DIR)/requirements.txt && \
          rm -rf ~/.cache/pip && \
          rm -f ../activate


rebuild: clean python2
rebuild2: rebuild
rebuild3: clean python3

#
# Install pybuild into an existing git repository so it can be used to
# build your venv in that project. Use this after you create a new
# project and it will set it up for use with a venv. You probably
# don't want to use this on a project that already has files in it
# because they could get clobbered. The list of files that will be
# clobbered is in $(PROJECT_FILES)
#
# Usage example:
#   $ make new REPO=ssh://github.com/yourname/your_existing_empty_repo
#
# This will clone the repo and install the pybuild files into the root
# of the repo, commit the changes, and push
#
new:
	set -e; \
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

test:
	echo $(ROOT_DIR)
	echo $(PROJECT_FILES)

.PHONY:	python2 python3 test new copy rebuild clean check_root
