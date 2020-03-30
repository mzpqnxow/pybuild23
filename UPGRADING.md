## Upgrading / Fixing

Note you will need `pip` for Python2 to perform the package install for Python2. It is very possible that a flag to `python3 -mpip instal ...` will force it to operate in Python2 mode, but for now stick with what is known to work. You won't need `pip3` since Python3 does a sane thing and ships with `pip3` and can be invoked using `python3 -mpip`

```
$ git clone ssh://github.com/mzpqnxow/pybuild23
$ cd pybuild23
$ rm -rf packages/lib/python2.7 packages/lib/python3.7 packages/bin
$ mv ~/.local ~/.local.bak
$ pip2 install --no-cache-dir --upgrade --log pip.log --isolated --user --no-binary :all: --ignore-installed --upgrade-strategy eager setuptools 'pip[socks]' virtualenv pysocks
$ python3 -mpip install --no-cache-dir --upgrade --log pip.log --isolated --user --no-binary :all: --ignore-installed --upgrade-strategy eager setuptools 'pip[socks]' virtualenv pysocks
...
$ cp -a ~/.local/lib/python3.7 ~/.local/lib/python2.7 packages/lib/
$ cp -a ~/.local/bin packages/bin
$ rm -rf ~/.local && mv ~/.local.bak ~/.local
```

You may need to or want to change the `#!/usr/bin/pythonX` line in each of the files in `packages/bin` to `#!/usr/bin/env pythonX` but this may not be necessary

```
$ git add packages
$ git commit packages -m 'updated packages for py2/py3'
$ git push
```

Things should work now. Also, you should be able to bootstrap when behind a socks server, which is convenient sometimes
