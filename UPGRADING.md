## Upgrading / fixing

```
$ mv ~/.local ~/.local.bak
$ python3 -mpip install --log pip.log --isolated --user --no-binary :all: -I setuptools 'pip[socks]' virtualenv
$ ls -l ~/.local/lib
$ ls -l ~/.local/bin
...
$ rm -rf ~/.local && mv ~/.local.bak ~/.local
```

Ditto for python2, for the most part
