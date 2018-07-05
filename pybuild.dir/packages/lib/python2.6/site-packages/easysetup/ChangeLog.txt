0.0.19 2015-05-14 ::

    Add .json to .gitignore.
	Improved pkl compatiblity btw py2 and py3.
	Code cleanup in common.py.

	
0.0.18 2015-05-13 ::

    Added PyPy and PyPy3 to .travis.yml.
	Corrected some encoding issues.
	Simplified some code.
	Added setup_cxf.py.
	Export Shippable test results to a file to make them visible from
	the management page.
	Simplified DATA_FILES in setup_py2exe.py.


0.0.17 2015-05-09 ::

    Add support for Appveyor.


0.0.16 2015-05-08 ::

    Changed data format to json.
	Improved Unicode compliance.
	Corrected yml files for Travis and Shippable.
	Replaced unicode() for .decode().
	Added comment_import_for_py2exe() and 
	uncomment_import_for_py2exe() in setup_utils.py to solve
	py2exe unicode errors (for the moment).

	
0.0.15 2015-05-04 ::

    Correct change_sphinx_theme().
	Correct requirements-dev.txt.
	Clarify some messages.

	
0.0.14 2015-05-02 ::

    Update .gitignore.


0.0.13 2015-05-02 ::

    Update usage template.
	Correct index.html.
	Update build.cmd.

	
0.0.12 2015-05-02 ::

    Include missing file in git (APPLICATION_NAME.py).


0.0.11 2015-05-02 ::

    Correct README.rst.
	Correct upd_usage_in_readme() text alignment.

	
0.0.10 2015-05-02 ::

    Recreates reference.rst in the doc directory on each build. Can be disabled
	inside build.cmd by remarking the REBUILD_REFERENCE=YES line.
	Checks PEP8 (flake8) and Py3 compatibility (pylint --py3k).
	Py3 compatibility check can be disabled inside build.cmd by remarking the 
	CHECK_PY3_COMPATIBILITY=YES line.
	Code cleanup.
	Change sphinx theme when in RTD.

	
0.0.9 2015-04-26 ::

    Remove Sphinx upload section from setup.cfg.
	Update README.rst.
	Save answers (DEFAULT_AUTHOR, DEFAULT_EMAIL, DEFAULT_URL, DEFAULT_VERSION 
	and DEFAULT_LICENSE) for future use in other applications.
	py2exe build now works with Py3 (tested with Anaconda).

	
0.0.8 2015-04-26 ::

    Add files and dirs to .gitignore.
	Correct setup_py2exe.py to include doc if exists.
	Add warning to py2exe build.
	Add ERRORLEVEL check when publishing dists to PyPI.

	
0.0.6 2015-04-26 ::

    Add dumb, msi and rpm options to build.cmd.
	Update README.rst.
	Correct os.linesep to '\n' in update_copyright() (setup-utils.py).

	
0.0.5 2015-04-25 ::

    Improve Py3 compatibility.
	Update rst files to improve docs.
	Add defaults to setup questions.
	Add build.cmd usage info.
	Update requirements.txt and requirements-dev.txt.
	Add delay between templates copying and renaming application directory.

	
0.0.4 2015-04-20 ::

    Update README.rst.
    Updates usage section in README.rst based on usage.txt (which resides 
	inside your application directory).


0.0.3 2015-04-20 ::

    Update README.rst.


0.0.2 2015-04-20 ::

    Remove rst2pdf module due to Py3 incompatibility.
    Add To do list to README.rst.


0.0.1 2015-04-19 ::

    Create build.cmd to build source, egg, wheel, win, py2exe, cxf (still not 
	working), doc and run tests.
    Add PyPI and PyPItest uploads.
    Create single file for setup info (appinfo.py) that can be used by the 
	application itself.
    Create templates for Travis, Shippable and tox.
    Create template for development requirements (requirements-dev.txt).
    Create empty template for installation requirements (requirements.txt).
    Create template for git VCS exceptions (.gitignore).
    Create template for files to be included in the setup (MANIFEST.in).
    Create template for a README file (README.rst).
    Create template for wheel setup and Sphinx documentation upload (setup.cfg).
    Create option (-d) to copy templates to doc dir (ncludes option -r below).
    Create option (-r) to update doc\reference.rst.
