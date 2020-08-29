compilerexplorer="${HOME}/git/github.com/mattgodbolt/compiler-explorer"
[[ -r "${compilerexplorer}/Makefile" ]] &&
    alias compiler-explorer="pd $(printf %q "${compilerexplorer}") make"
unset compilerexplorer

[[ -r "/etc/bashrc" ]] && source "/etc/bashrc"

[[ "${HOSTNAME}" == "iris"* && -r ~/".iris_bashrc" ]] && source ~/".iris_bashrc"

for completion in "${COMPLETIONS[@]}"
do
    complete ${completion}
done
unset completion

