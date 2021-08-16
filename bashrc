HISTCONTROL=ignoreboth
# ~1 yr 5mo on a laptop
HISTSIZE=$((100 * 1000))
HISTTIMEFORMAT="%s;"
shopt -s histappend

if [ -f /usr/bin/virtualenvwrapper_lazy.sh ]; then
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
    source /usr/bin/virtualenvwrapper_lazy.sh
fi

alias sl=ls
alias rg="RIPGREP_CONFIG_PATH=$HOME/.ripgreprc rg"
