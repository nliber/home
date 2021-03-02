compilerexplorer="${HOME}/git/github.com/mattgodbolt/compiler-explorer"
[[ -r "${compilerexplorer}/Makefile" ]] &&
    alias compiler-explorer="pd $(printf %q "${compilerexplorer}") make"
unset compilerexplorer

[[ -r "/etc/bashrc" ]] && source "/etc/bashrc"

for hostname in ${ANL_HOSTNAMES}
do
    hostnamebashrc="${HOME}/.${hostname}_bashrc"
[[ "${HOSTNAME}" == "${hostname}"* && -r "${hostnamebashrc}" ]] && source "${hostnamebashrc}"
done
unset hostnamebashrc
unset hostname

for completion in "${COMPLETIONS[@]}"
do
    complete ${completion}
done
unset completion

