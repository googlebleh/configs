if [ -d $HOME/.local/bin ]; then
    PATH="$PATH:$HOME/.local/bin"
fi

rm_fast ()
{
	mv "$1" "$1.tmp"
	rm -rf "$1.tmp" &
}


# interactive-only shell config below
[[ $- != *i* ]] && return


# unlimited history file
HISTSIZE=
HISTFILESIZE=
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%s;"
shopt -s histappend

source_one ()
{
    for fpath in "$@"; do
	if [ ! -f "$fpath" ]; then
	    continue
	fi
	if source "$fpath"; then
	    return "$?"
	fi
    done
    return 1
}

if command -v fzf &> /dev/null; then
    # Arch (first below) and Ubuntu install these to different paths
    source_one /usr/share/fzf/completion.bash /usr/share/doc/fzf/examples/completion.bash
    source_one /usr/share/fzf/key-bindings.bash /usr/share/doc/fzf/examples/key-bindings.bash
fi

if source_one /usr/bin/virtualenvwrapper_lazy.sh; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
fi

alias grep="grep --color"
alias ls="ls --color"
alias rg="RIPGREP_CONFIG_PATH=$HOME/.ripgreprc rg"
alias sl=ls
# export MANPAGER="less -R --use-color -Dd+c -Du+m"
