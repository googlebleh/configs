bash_ps1_color ()
{
    local rv="$?"

    local GREEN="\[\033[0;32m\]"
    local CYAN="\[\033[0;36m\]"
    local RED="\[\033[0;31m\]"
    local PURPLE="\[\033[0;35m\]"
    local BROWN="\[\033[0;33m\]"
    local LIGHT_GRAY="\[\033[0;37m\]"
    local LIGHT_BLUE="\[\033[1;34m\]"
    local LIGHT_GREEN="\[\033[1;32m\]"
    local LIGHT_CYAN="\[\033[1;36m\]"
    local LIGHT_RED="\[\033[1;31m\]"
    local LIGHT_PURPLE="\[\033[1;35m\]"
    local YELLOW="\[\033[1;33m\]"
    local WHITE="\[\033[1;37m\]"
    local RESTORE="\[\033[0m\]"

    local branch branch_s="" rv_s=""
    local date_s
    
    date_s="$(date +%H:%M:%S)"

    if [[ $rv != 0 ]]; then
        rv_s="$rv "
    fi
    if which git &>/dev/null; then
	branch="$(git branch 2>/dev/null | grep \* | cut -d " " -f 2)"
	branch_s="$branch"
    fi

    PS1="\n$GREEN\u@\h$RESTORE $date_s $CYAN\w$RESTORE $LIGHT_PURPLE$branch_s$RESTORE"
    PS1+="\n$LIGHT_RED$rv_s$RESTORE\$ "
    export PS1
}
