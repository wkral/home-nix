{ writeShellScriptBin }:
writeShellScriptBin "newbranch" ''

usage() {
    cat << EOT
Usage: newbranch [-s <source-branch>] <issue> <title>

EOT
}

err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] Error: $@" >&2
    usage
    exit 1
}

parseCommand() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        err "Not inside a git repo"
    fi

    SOURCE=master
    while getopts ":s:" opt; do
        case $opt in
            s)  if ! (git branch -a --list | grep "$OPTARG" > /dev/null 2>&1); then
                err "Could not find $OPTARG branch in git repo."
            fi
            readonly SOURCE=$OPTARG
            ;;
            \?) err "Invalid option: -$OPTARG"
            ;;
            :)  err "Option -$OPTARG requires an argument."
            ;;
        esac
    done

    shift $((OPTIND-1))

    if [[ $# != 2 ]]; then
        err "Requires issue number and name to proceed"
    fi

    local re='^[0-9]+$'
    if ! [[ ''${1} =~ ''${re} ]]; then
        err "Issue must be numeric"
    fi

    readonly ISSUE=$1
    readonly TITLE=$(echo "$2" | tr '[:upper:]' '[:lower:]' | xargs | \
                       sed -e 's/[[:space:]]/-/g')
}

createBranch() {
    if ! (git checkout "''${SOURCE}" && git pull); then
        err "Failed to checkout and pull branch: ''${SOURCE}"
    fi

    local branch="OP-''${ISSUE}-''${TITLE}"
    git checkout -b ''${branch}
    git push -u origin ''${branch}
}

parseCommand "''${@}"
createBranch
''
