# Installation scripts

`setup.sh` uses [`realpath`](https://www.gnu.org/software/coreutils/manual/html_node/realpath-invocation.html) module from GNU coreutils to manipulate with path to files and directories. That is why this module has to be installed in your OS.

To check that the module is installed just call next command:

```shell
command -v {module name}
```

If module is installed the path with description will be depicted.

For MacOS installation you can use [brew package manager](https://formulae.brew.sh/formula/coreutils)
