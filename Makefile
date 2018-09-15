#############################################################################
# Universal pybuild @ Company.com Makefile
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
#            user with Company  Artifactory. Only needed once on any given
#            system, not per project, since pypirc is global to the user
#            and not respected by virtualenv
#
# Remember that PYTHON and PYTHON3 can be overridden on the command line
# using `make PYTHON=/opt/my/python`. The same is true of the VENV_DIR
# but there's really no reason to change the venv dir IMO.
#
# How does this work? This is all from pybuild, an old project of mine
# and a friend, @ github.com/mzpqnxow/pybuild23. It is public and free
# but copyrighted by me. It was not developed on Company time and
# actually predates my current employer by quite a bit, though the
# repository has been created and destroyed several times over the last
# few years. There are at least a few commits with the wrong ~/.gitconfig
# setting, so about 95% of commits were made from home with my account
# information, while 5% were made with another company ID, as I was working
# on company code at the time. :>#
#
# - AG, 2018
##############################################################################
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
STABLE_DEPLOYMENTS_PATH := repeatable-deployments/
STABLE_DEPLOYMENT_FILE := requirements.txt-frozen-deploy-
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

publish:
	git push && python setup.py sdist upload -r local && \
	make clean

freeze:
	$(PYBUILD) --freeze $(VENV_DIR) && \
          echo "Versions of all packages and their dependencies has been stashed in" && \
          echo "the $(STABLE_DEPLOYMENTS_PATH) directory. Press enter and it will be" && \
          echo -n "auto-added/committed for you, or press control-C to cancel ..." && \
          git add $(STABLE_DEPLOYMENTS_PATH)/$(STABLE_DEPLOYMENT_FILE)$(shell date +%Y-%m-%d) && \
          git commit -m 'Added a frozen requirements.txt file for stable deployment' 

pypirc:
	@echo '-------- Company PyPirc Installation --------'
	echo ''
	echo 'Follow the prompts to install a ~/.pypirc file that allows you to publish to Company Artifactory'
	echo 'WARN: This is a global configuration file for your username ($$USER)'
	echo 'NOTICE: Any existing ~/.pypirc will be backed up in ~/.pypirc.bak.*'
	echo '-------- Company AD PyPirc Crdentials --------'
	echo 'Please enter your credentials and a PyPirc file will be created'
	echo 'SECURITY: The file will be stored mode 0600 in ~/.pypirc, private from other users :>'
	echo
	cp ~/.pypirc ~/.pypirc.bak.$(date +%s) && \
	echo -n 'Please enter Company AD username (without @company.com): ' && \
	read user && \
	echo -n 'Please enter Company AD password: ' && \
	read pass && \
	sed \
          -e "s/%%USER%%/$$user/" \
          -e "s/%%PASS%%/$$pass/" \
          $(PYPIRC) > ~/.pypirc && \
          chmod 600 ~/.pypirc && \
          echo "Installation complete, `make publish` should now work for you" 


clean:
	TMPFILE=`mktemp` && \
	  cp venv/requirements.txt $$TMPFILE && \
          rm -rf $(VENV_DIR) && \
          mkdir $(VENV_DIR) && \
          mv $$TMPFILE $(VENV_DIR)/requirements.txt && \
          rm -f $(PACKAGES)/{$(SYMLINKS)}

rebuild: clean all
again: rebuild  # Aliases
more: rebuild  # Aliases

test:
	echo IT WORKS

.PHONY:	python2 python3 rebuild clean pypirc publish all test
