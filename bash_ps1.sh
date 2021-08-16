get_git_head_failfast ()
{
    local branch_s=""
    local detached_head exit_status

    if ! which git &>/dev/null; then
        echo "$branch_s"
        return 0
    fi

    branch_s="$(timeout 0.2 git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ "$branch_s" != "HEAD" ]; then
        echo "$branch_s"
        return 0
    fi

    # might be a detached head, try again
    # branch_s="$(git show -s --pretty='%D' HEAD | sed 's/^.\+\?, //')"
    detached_head="$(timeout 0.6 git name-rev --name-only HEAD)"
    exit_status="$?"
    if [ "$exit_status" -eq "124" ] || [ "$exit_status" -eq "137" ]; then
        # don't wait too long
        echo "$branch_s"
    else
        echo "$detached_head"
    fi
    return 0
}

bash_ps1_color ()
{
    local rv="$?"
    history -a

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

    local date_s
    local branch_s="" rv_s=""
    local venv_s venv_line=""

    PS1=""

    date_s="$(date +%H:%M:%S)"

    if [[ $rv != 0 ]]; then
        rv_s="$rv "
    fi

    branch_s="$(get_git_head_failfast)"

    if [ -n "$VIRTUAL_ENV" ]; then
        venv_s="$(basename $VIRTUAL_ENV)"
        venv_line="\n($venv_s)"
    fi

    PS1+="\n$GREEN\u@\h$RESTORE $date_s $CYAN\w$RESTORE $LIGHT_PURPLE$branch_s$RESTORE"
    PS1+="$venv_line"
    PS1+="\n$LIGHT_RED$rv_s$RESTORE\$ "
    export PS1
}
