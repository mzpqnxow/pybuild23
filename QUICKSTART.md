## Get started right away without understanding anything (!)

Skip the README and get started

## First...

Try the -devel branch ... the layout might be less overwhelming to the eye, and less confusing

## Starting a fresh project

If you are starting with an empty project and nothing yet in source control, try this

### Python 3 based virtualenv

```
$ $EDITOR venv/requirements.txt [add your dependencies into the file]
$ make && source venv/bin/activatec
$ rm -rf .git
$ [start your development and use git as usual]
```


### Python 2 based virtualenv (default)

```
$ $EDITOR venv/requirements.txt [add your dependencies into the file]
$ make && source venv/bin/activate
$ rm -rf .git
$ [start your development and use git as usual]
```

## If you want to "install" pybuild23 into an existing (preferably freshly created) git repository

First, you should be careful. If your repository already has files in it and there is a name collision with pybuild23 files (i.e. venv/, Makefile, etc.) you could end up with things overwritten. You should really start with a fresh repository, else manually copy pybuild23 into the existing repository

OK, with that out of the way...

```
$ make new REPO=ssh://github.com/yourname/yourproject
$ cd ../yourproject
$ $EDITOR venv/requirements.txt [add your dependencies into the file]
```

## If you want to "install" pybuild23 into an existing project that is already checked out on your local filesystem

```
$ cd /your/checkedout/repo
$ git clone https://github.com/mzpqnxow/pybuild23
$ cp -r pybuild23/{venv,Makefile,packages,etc} .
$ rm -rf pybuild23
$ git add venv Makefile packages etc
$ git commit venv Makefile packages etc
$ git push
``` 

## If you have a project deployed via pybuild23 and you want to save the versions via pip freeze in a dated file

```
$ make freeze
```
