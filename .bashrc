compilerexplorer="${HOME}/git/github.com/mattgodbolt/compiler-explorer"
if [[ -r "${compilerexplorer}/Makefile" ]]
then
    alias compiler-explorer="pd $(printf %q "${compilerexplorer}") make"
fi
unset compilerexplorer

