## TODO

There isn't much left, this tool is meant for one very narrow purpose: deploying apps in a simple, repeatable way across platforms that may or may not have pip or virtualenv on them. It's annoying installing them by hand.

But off the top of my head:

* Rewrite the #! line in the packages/bin directory dynamically (is this necessary? I think not, we invoke with python ourselves don't we)
* More Python 3 testing (I don't use Python3, I live in the 90's)
* Rebuild packages and strip out twine, and one or two other things that just aren't needed
* Better documentation / automation
* Think more about what "base metapackages" should be included in *every* Python project and add them to `venv/requirements.txt` where linters are already present
* Switch the `publish` target to use the new Twine tools as old methods of publishing are officially deprecated. Twine has a lot of new security features, so it's probably a good idea.
* More documentation regarding etc/pip.ini (that's actually really important your bootstrap and your virtualenv will use these settings
* Consider switching to utilizing `pipenv` over `requirements.txt` - may lose import functionality here thought.
