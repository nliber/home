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

export CDPATH="\
:\
${HOME}:\
${HOME}/git/github.com/nliber:\
${HOME}/silly:\
/usr/local/include:\
"

export PATH="\
${HOME}/bin\
:${HOME}/.local/bin\
:${PATH}\
:\
"

search_path()
{
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

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
