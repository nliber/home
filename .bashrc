compilerexplorer="${HOME}/git/github.com/mattgodbolt/compiler-explorer"
[[ -r "${compilerexplorer}/Makefile" ]] &&
    alias compiler-explorer="pd $(printf %q "${compilerexplorer}") make"
unset compilerexplorer

[[ -r "/etc/bashrc" ]] && source "/etc/bashrc"

jlseloginrc="${HOME}/.jlselogin_bashrc"
[[ "${HOSTNAME}" == "jlselogin"* && -r "${jlseloginrc}" ]] && source "${jlseloginrc}"
unset jlseloginrc

irisbashrc="${HOME}/.iris_bashrc"
[[ "${HOSTNAME}" == "iris"* && -r "${irisbashrc}" ]] && source "${irisbashrc}"
unset irisbashrc

itbashrc="${HOME}/.it_bashrc"
[[ "${HOSTNAME}" == "it"* && -r "${itbashrc}" ]] && source "${itbashrc}"
unset itbashrc

for completion in "${COMPLETIONS[@]}"
do
    complete ${completion}
done
unset completion

