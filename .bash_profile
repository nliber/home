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
    eval ${1}=\""${path}"\"
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
    eval ${1}=\""${path}"\"
}
export -f prepend_path

jobs()
{
    builtin jobs -l "${@}"
}
export jobs

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

prepend_path PATH \
"${HOME}/bin" \
"${HOME}/.local/bin" \
"/Applications/CMake.app/Contents/bin" \
"/soft/buildtools/cmake-3.13.3/bin" \
"/Applications/MacVim.app/Contents/bin" \
"${HOME}/vim/bin" \
"${HOME}/gdb/bin" \
"/usr/local/gcc/bin" \
"/usr/local/clang/bin" \

append_path  PATH \
"/Applications/Araxis Merge.app/Contents/Utilities" \
"." \

export CDPATH
append_path CDPATH \
"." \
"${HOME}" \
"${HOME}/git/github.com/nliber" \
"${HOME}/silly" \
"/usr/local/include" \

for gitcompletion in "/usr/local/git/contrib/completion/git-completion.bash" "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
do
    if [[ -r "${gitcompletion}" ]] && source "${gitcompletion}"
    then
        break
    fi
done
unset gitcompletion

export brew="/usr/local/bin/brew"
if [[ -x "${brew}" ]]
then
    for brewcompletion in $(${brew} --prefix)/etc/bash_completion.d/*
    do
        [[ -r "${brewcompletion}" ]] && source "${brewcompletion}"
    done
    unset brewcompletion
fi
unset brew

iterm2shellintegration="${HOME}/.iterm2_shell_integration.bash"
[[ -r "${iterm2shellintegration}" ]] && source "${iterm2shellintegration}"
unset iterm2shellintegration

