[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth
# ~1 yr 5mo on a laptop
HISTSIZE=$((100 * 1000))
HISTTIMEFORMAT="%s;"
shopt -s histappend

export MANPAGER="less -R --use-color -Dd+c -Du+m"

if [ -d $HOME/.local/bin ]; then
    PATH="$PATH:$HOME/.local/bin"
fi

if [ -f /usr/bin/virtualenvwrapper_lazy.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
    source /usr/bin/virtualenvwrapper_lazy.sh
fi

alias grep="grep --color"
alias ls="ls --color"
alias rg="RIPGREP_CONFIG_PATH=$HOME/.ripgreprc rg"
alias sl=ls

rm_fast ()
{
	mv "$1" "$1.tmp"
	rm -rf "$1.tmp" &
}
