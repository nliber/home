compilerexplorer="${HOME}/git/github.com/mattgodbolt/compiler-explorer"
[[ -r "${compilerexplorer}/Makefile" ]] &&
    alias compiler-explorer="pd $(printf %q "${compilerexplorer}") make"
unset compilerexplorer

[[ -r "/etc/bashrc" ]] && source "/etc/bashrc"

