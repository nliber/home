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
export GREP_COLOR=auto
export GZIP="--best"

BrewBashCompletion="$(brew --repository)/Library/Contributions/brew_bash_completion.sh"
if [[ -r "${BrewBashCompletion}" ]]
then
    source "${BrewBashCompletion}"
fi
unset BrewBashCompletion



export BOOST_ROOT="/usr/local/boost_1_59_0"

export HOMEBREW_GITHUB_API_TOKEN="fc202e35f54d9a248ba34aa2c2b7324b942354d2"

export CDPATH="\
:\
${HOME}:\
${HOME}/git/github.com/nliber:\
"

export PATH="\
${HOME}/bin\
:${PATH}\
:/Applications/Araxis Merge.app/Contents/Utilities\
:\
"
export HDF5_ROOT="/usr/local/hdf5"
