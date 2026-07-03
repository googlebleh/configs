bash_ps1_allow_repo ()
{
    local allowfile="${XDG_CONFIG_HOME:-$HOME/.config}/bash_ps1_git_allowlist"

    abspath="$(realpath -- "$PWD" 2>/dev/null)" || return 1
    relpath="$(realpath --relative-to "$HOME" "$PWD" 2>/dev/null)" || return 1
    [ "$abspath" -ef "$HOME/$relpath" ] || return 1

    if ! command -v git 2>&1 >/dev/null || ! command -v timeout 2>&1 >/dev/null; then
        echo "missing dependencies"
        return 1
    fi

    if _git_repo_allowed; then
        return 0
    fi

    if [[ "$abspath" == "$HOME"* ]]; then
        echo "~/$relpath" >> "$allowfile"
    else
        echo "$abspath" >> "$allowfile"
    fi
}

_git_repo_allowed ()
{
    local allowfile="${XDG_CONFIG_HOME:-$HOME/.config}/bash_ps1_git_allowlist"
    local here

    here="$(realpath -- "$PWD" 2>/dev/null)" || return 1
    _git_repo_allowed_scan "$allowfile" "$here" 0
}

# Scan an allowlist file for a prefix matching $here
#   - a leading ~/ is expanded
#   - blank lines and # comments are ignored
#   - "#include <path>" resolves relative to the including file's directory
_git_repo_allowed_scan ()
{
    local file="$1" here="$2" depth="$3"
    local line prefix incfile

    [ "$depth" -gt 16 ] && return 1
    [ -r "$file" ] || return 1
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            '#include'[[:space:]]*)
                incfile="${line#\#include}"
                incfile="${incfile#"${incfile%%[![:space:]]*}"}"  # ltrim
                case "$incfile" in
                    '~/'*) incfile="$HOME/${incfile#\~/}" ;;
                esac
                case "$incfile" in
                    /*) ;;
                    *) incfile="$(dirname -- "$file")/$incfile" ;;
                esac
                _git_repo_allowed_scan "$incfile" "$here" "$((depth + 1))" && return 0
                continue
                ;;
            ''|'#'*) continue ;;
            '~/'*) line="$HOME/${line#\~/}" ;;
        esac
        prefix="$(realpath -- "$line" 2>/dev/null)" || continue
        if [ "$here" = "$prefix" ] || [ "${here#"$prefix"/}" != "$here" ]; then
            return 0
        fi
    done < "$file"
    return 1
}

_get_git_head_failfast ()
{
    local branch_s=""
    local detached_head exit_status

    if ! _git_repo_allowed; then
        return 0
    fi

    branch_s="$(timeout 0.2 git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ "$branch_s" != "HEAD" ]; then
        echo "$branch_s"
        return 0
    fi

    # might be a detached head, try again
    # branch_s="$(git show -s --pretty='%D' HEAD | sed 's/^.\+\?, //')"
    detached_head="$(timeout 0.6 git name-rev --name-only HEAD 2>/dev/null)"
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

    netns_s=""
    if which ip > /dev/null; then
        netns_s="$(ip netns identify $$ | head -c -1)"
        if [ ${#netns_s} -ge 1 ]; then
            netns_s="$RED[$netns_s]$RESTORE"
        fi
    fi

    date_s="$(date +%H:%M:%S)"

    if [[ $rv != 0 ]]; then
        rv_s="$rv "
    fi

    branch_s="$(_get_git_head_failfast)"

    if [ -n "$CONDA_DEFAULT_ENV" ]; then
        venv_s="$(basename $CONDA_DEFAULT_ENV)"
        venv_line="\n($venv_s)"
    elif [ -n "$VIRTUAL_ENV" ]; then
        venv_s="$(basename $VIRTUAL_ENV)"
        venv_line="\n($venv_s)"
    fi

    PS1+="\n$GREEN\u@\h$RESTORE$netns_s $date_s $CYAN\w$RESTORE $LIGHT_PURPLE$branch_s$RESTORE"
    PS1+="$venv_line"
    PS1+="\n$LIGHT_RED$rv_s$RESTORE\$ "
    export PS1
}
