ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON = /usr/bin/python
PYTHON3 = /usr/bin/python3
VENV_DIR = venv/
RM_RF := /bin/rm -rf
PYBUILD := ./pybuild
BUILD_FILES := build dist *.egg-info
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

publish:
	git push && python setup.py sdist upload -r local
	make clean

clean:
	TMPFILE=`mktemp` && \
	  cp venv/requirements.txt $$TMPFILE && \
          rm -rf $(BUILD_FILES) && \
          rm -rf $(VENV_DIR) && \
          mkdir $(VENV_DIR) && \
          mv $$TMPFILE $(VENV_DIR)/requirements.txt #&& \
          #rm -rf ~/.cache/pip

rebuild: clean all

.PHONY:	python2 python3 rebuild clean
