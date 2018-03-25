## Get started right away without understanding anything (!)

Skip the README and get started

## Starting a fresh project

If you are starting with an empty project and nothing yet in source control, try this

### Python 3 based virtualenv

```
$ make python3
$ rm -rf .git
```


### Python 2 based virtualenv (default)

```
$ make
$ rm -rf .git
```

## If you want to "install" pybuild23 into an existing (preferably freshly created) git repository

`$ make new REPO=ssh://github.com/yourname/yourproject`
