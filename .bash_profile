export COMPLETIONS

pd()
{
    case "${#}" in
        0)
            pushd . && cd
            ;;
        1)
            pushd "${1}"
            ;;
        *)
            (cd "${1}" && shift && "${@}")
            ;;
    esac
}
export -f pd

search_path()
{
    if ((1 > "${#}" || 2 < "${#}"))
    then
        printf "Usage: %q directory [ path ]\n" "${FUNCNAME}" >&2
        return 2
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

pend_path()
{
    if ((${#} != 4))
    then
        printf "Usage: %q funcname path_variable path directory\n" "${FUNCNAME}" >&2
        return 2
    fi

    local funcname="${1}"
    local path_variable="${2}"
    local path="${3}"
    local directory="${4}"

    if search_path "${directory}" "${path}"
    then
        printf "%q: %q already in %q=%q\n" "${funcname}" "${directory}" "${path_variable}" "${path}" >&2
        return 1
    fi

    if [[ "${directory:0:1}" != "/" ]] && [[ "${directory}" != '.' ]]
    then
        printf "%q: %q not an absolute directory path\n" "${funcname}" "${directory}" >&2
        return 3
    fi

    if  [[ ! -d "${directory}" ]] || [[ ! -x "${directory}" ]]
    then
        printf "%q: %q not an executable directory\n" "${funcname}" "${directory}" >&2
        return 4
    fi

    return 0
}
export -f pend_path

_pend_path()
{
    if ((1 == "${COMP_CWORD}"))
    then
        COMPREPLY=($(compgen -v "${COMP_WORDS["${COMP_CWORD}"]}"))
    fi
}
export -f _pend_path

prepend_path()
{
    if (("${#}" < 1))
    then
        printf "Usage: %q path_variable [ directory ... ]\n" "${FUNCNAME}" >&2
        return 2
    fi

    local path="${!1}"
    local i
    for ((i="${#}"; 1 < i; --i))
    do
        local directory="${!i}"
        if pend_path "${FUNCNAME}" "${1}" "${path}" "${directory}"
        then
            path="${directory}:${path}"
        fi
    done
    eval ${1}=\""${path}"\"
}
export -f prepend_path
COMPLETIONS+=("-o dirnames -F _pend_path prepend_path")

append_path()
{
    if (("${#}" < 1))
    then
        printf "Usage: %q path_variable [ directory ... ]\n" "${FUNCNAME}" >&2
        return 2
    fi

    local path="${!1}"
    local i
    for ((i=2; i <= "${#}"; ++i))
    do
        local directory="${!i}"
        if pend_path "${FUNCNAME}" "${1}" "${path}" "${directory}"
        then
            path="${path}:${directory}"
        fi
    done
    eval ${1}=\""${path}"\"
}
export -f append_path
COMPLETIONS+=("-o dirnames -F _pend_path append_path")

erase_path()
{
    if ((${#} < 1))
    then
        printf "Usage: %q path_variable [ directory ... ]\n" "${FUNCNAME}" >&2
        return 2
    fi

    local path="${!1}"
    local errors=0
    local d
    for ((d=2; d<="${#}"; ++d))
    do
        local directory="${!d}"
        if ! search_path "${directory}" "${path}"
        then
            : $((++errors))
            printf "%q: %q not in %q=%q\n" "${FUNCNAME}" "${directory}" "${1}" "${path}" >&2
            continue
        fi

        # Remove :$directory: from :$path:
        path=":${path}:"
        local lpath="${path%%:"${directory}":*}"
        local rpath="${path##*:"${directory}":}"

        # Remove colons around $lpath and $rpath
        lpath="${lpath#:}"
        lpath="${lpath%:}"
        rpath="${rpath#:}"
        rpath="${rpath%:}"

        # If both $lpath and $rpath are empty,
        # removing $directory from the middle needing a ':' between $lpath & $rpath
        # otherwise, removing $directory from one end and ':' not needed
        if [[ ! -z "${lpath}" && ! -z "${rpath}" ]]
        then
            path="${lpath}:${rpath}"
        else
            path="${lpath}${rpath}"
        fi
    done

    # set the actual path_variable passed in
    eval "${1}"=\""${path}"\"

    return $((errors ? 1 : 0))
}
export -f erase_path

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

export CMAKE_COLOR_DIAGNOSTICS="ON"
export CMAKE_EXPORT_COMPILE_COMMANDS="ON"
export CMAKE_GENERATOR="Unix Makefiles"

eval `brew shellenv` 2> "/dev/null"
prepend_path PATH \
"${HOME}/bin" \
"${HOME}/.local/bin" \
"/Applications/CMake.app/Contents/bin" \
"/Applications/MacVim.app/Contents/bin" \
"${HOME}/vim/bin" \
"${HOME}/gdb/bin" \
2> /dev/null

append_path  PATH \
"/Applications/Araxis Merge.app/Contents/Utilities" \
"${HOME}/bear/bin" \
"." \
2> "/dev/null"

export CDPATH
append_path CDPATH \
"." \
"${HOME}" \
/gpfs/jlse-fs0/users/nliber \
"${HOME}/git/github.com/nliber" \
"${HOME}/silly" \
"/usr/local/include" \
"${HOME}/git/github.com" \
2> "/dev/null"

export LIBRARY_PATH
append_path LIBRARY_PATH \
"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib" \
2> "/dev/null"

export LD_LIBRARY_PATH

export DYLD_LIBRARY_PATH
prepend_path DYLD_LIBRARY_PATH \
"/usr/local/tbb-2019_U6/lib" \
2> "/dev/null"

export MODULEPATH
append_path MODULEPATH \
"/soft/modulefiles" \
"/soft/restricted/CNDA/modulefiles" \
"/soft/restricted/intel_dga/modulefiles" \
2> "/dev/null"

export KOKKOS_PATH
export CLANG_FORMAT_EXE="${HOME}"/.vim/bundle/vim-clang-format/clang-format

export GH_DEBUG=api


for gitcompletion in "/usr/local/git/contrib/completion/git-completion.bash" "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
do
    if [[ -r "${gitcompletion}" ]] && source "${gitcompletion}"
    then
        break
    fi
done
unset gitcompletion

export brew="${HOMEBREW_PERFIX}/bin/brew"
if [[ -x "${brew}" ]]
then
    for brewcompletion in $(${brew} --prefix)/etc/bash_completion.d/*
    do
        [[ -r "${brewcompletion}" ]] && source "${brewcompletion}"
    done
fi
unset brewcompletion
unset brew

declare -x GH_DEBUG="1"

iterm2shellintegration="${HOME}/.iterm2_shell_integration.bash"
[[ -r "${iterm2shellintegration}" ]] && source "${iterm2shellintegration}"
unset iterm2shellintegration

modulesinit="/usr/local/opt/modules/init/bash"
[[ -r "${modulesinit}" ]] && source "${modulesinit}"
unset modulesinit

# can't use an array since exporting them does nothing,
# so we'll parse w/o quotes
declare -x ANL_HOSTNAMES="iris it jlselogin"
for hostname in ${ANL_HOSTNAMES}
do
    hostnamebashprofile="${HOME}/.${hostname}_bash_profile"
    [[ "${HOSTNAME}" == "${hostname}"* && -r "${hostnamebashprofile}" ]] && source "${hostnamebashprofile}"
done
unset hostnamebashprofile
unset hostname

if [[ -r "${HOME}/.bashrc" ]]
then
    ps1="${PS1}"
    source "${HOME}/.bashrc"
    PS1="${ps1}"
fi

# Need this after bashrc, otherwise warning about GREP_OPTIONS
spack="/soft/spack/share/spack/setup-env.sh"
[[ -r "${spack}" ]] && source "${spack}"
unset spack

