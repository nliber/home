compilerexplorer="${HOME}/git/github.com/mattgodbolt/compiler-explorer"
[[ -r "${compilerexplorer}/Makefile" ]] &&
    alias compiler-explorer="pd $(printf %q "${compilerexplorer}") make"
unset compilerexplorer

[[ -r "/etc/bashrc" ]] && source "/etc/bashrc"

irisbashrc="${HOME}/.iris_bashrc"
[[ "${HOSTNAME}" == "iris"* && -r "${irisbashrc}" ]] && source "${irisbashrc}"
unset irisbashrc

itbashrc="${HOME}/.it_bashrc"
[[ "${HOSTNAME}" == "iris"* && -r "${irisbashrc}" ]] && source "${irisbashrc}"
unset irisbashrc

for completion in "${COMPLETIONS[@]}"
do
    complete ${completion}
done
unset completion

