search_path()
{
    if ((1 > "${#}" || 2 < "${#}"))
    then
        echo "Usage: ${FUNCNAME} directory [ path ]" >&2
        return 1
    fi

    # default to $PATH and surround with colons
    local path=:"${2:-"${PATH}"}":

    # Is it a middle component on the path?
    if [[ "${path##*:"${1}":*}" == "" ]]
    then
        return 0
    else
        return 1
    fi
}
export -f search_path

prepend_path()
{
    if (("${#}" < 1))
    then
        echo "Usage: ${FUNCNAME} path_variable [ directory ... ]" >&2
        return 1
    fi

    local path="${!1}"
    local i
    for ((i="${#}"; 1 < i; --i))
    do
        local directory="${!i}"
        if [[ -d "${directory}" ]] && [[ -x "${directory}" ]] && ! search_path "${directory}" "${path}"
        then
            path="${directory}:${path}"
        fi
    done
    eval ${1}="${path}"
}
export -f prepend_path

append_path()
{
    if (("${#}" < 1))
    then
        echo "Usage: ${FUNCNAME} path_variable [ directory ... ]" >&2
        return 1
    fi

    local path="${!1}"
    local i
    for ((i=2; i <= "${#}"; ++i))
    do
        local directory="${!i}"
        if [[ -d "${directory}" ]] && [[ -x "${directory}" ]] && ! search_path "${directory}" "${path}"
        then
            path="${path}:${directory}"
        fi
    done
    eval ${1}="${path}"
}
export -f prepend_path

#export PS1="[\$PWD]\\$ "
export PS1="[//\h\w]\\$ "
ColorBashPrompt="${HOME}/.color_bash_prompt.sh"
if [[ -r "${ColorBashPrompt}" ]]
then
    source "${ColorBashPrompt}"
    if [[ "${EUID}" == "0" ]]
    then
        PS1="\[${BIRed}\][\[${Red}\]//\h\[${BIRed}\]\w]\\$\[${Color_Off}\] "
    else
        PS1="\[${BICyan}\][\[${Cyan}\]//\h\[${BICyan}\]\w]\\$\[${Color_Off}\] "
    fi
fi
unset ColorBashPrompt

export HISTSIZE="2147483647"
export HISTFILESIZE="${HISTSIZE}"
export HISTCONTROL="ignoredups"
export HISTTIMEFORMAT=""

set -o vi
export FCEDIT="vi"
export EDITOR="${FCEDIT}"
export VISUAL="${FCEDIT}"

export CLICOLOR=auto
export GCC_COLORS=auto
export GREP_OPTIONS="--color=auto"
export GZIP="--best"

BrewBashCompletion="$(brew --repository)/Library/Contributions/brew_bash_completion.sh"
if [[ -r "${BrewBashCompletion}" ]]
then
    source "${BrewBashCompletion}"
fi
unset BrewBashCompletion

#export GCC_ROOT="/usr/local/gcc-7.2"
#export CLANG_ROOT="/usr/local/clang+llvm-5.0.0-x86_64-apple-darwin"

export CDPATH
append_path CDPATH "." "${HOME}" "${HOME}/git/github.com/nliber" "${HOME}/silly" "/usr/local/include"

prepend_path PATH "${HOME}/bin" "${HOME}/.local/bin"
append_path  PATH "."

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

