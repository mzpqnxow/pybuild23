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
PYTHON = `which python2`
PYTHON3 = `which python3`
RUNNING_USER = `whoami`
VENV_DIR = venv/
RM_RF := /bin/rm -rf
PYBUILD := ./pybuild
PROJECT_FILES := etc packages pybuild .gitignore examples/Makefile
COPY_FILES := etc packages pybuild examples/Makefile venv


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

check_root:
	@[ $(RUNNING_USER) != "root" ] || (echo Disallowing clean as root user; /bin/false)

clean: check_root
	TMPFILE=`mktemp` && \
	  cp venv/requirements.txt $$TMPFILE && \
          rm -rf $(VENV_DIR) && \
          mkdir $(VENV_DIR) && \
          mv $$TMPFILE $(VENV_DIR)/requirements.txt #&& \
          #rm -rf ~/.cache/pip

rebuild: clean all

#
# Install pybuild into a specified directory
#
copy:
	@echo "Copying pybuild to $(DIR)"
	@ls -ld $(DIR)
	@cp -r $(COPY_FILES) $(DIR)
	@echo "Copied pybuild to $(DIR)"
	@echo "Set your depencies in $(DIR)/venv/requirements.txt"
	@echo "The default dependencies have been set as follows:"
	@echo
	@echo "--- start $(DIR)/venv/requirements.txt ---"
	@cat $(DIR)/venv/requirements.txt
	@echo "--- end $(DIR)/venv/requirements.txt ---"
	@echo
	@echo "You can use the following to build and activate your virtualenv now:"
	@echo
	@echo "$ pushd $(DIR)"
	@echo "$ make"
	@echo "$ source venv/bin/activate"
	@echo

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
