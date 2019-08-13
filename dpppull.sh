#!/bin/bash

MERGE=false
DIRS=("C:/DPPSource/dpp-platform-base" "C:/DPPSource/dpp8" "C:/DPPSource/dpp7")

pull() {
    REPODIR=$1
    cd ${REPODIR}
    # BRANCH=$(git br | grep \* | cut -d ' ' -f2)
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    REPO=$(git remote show -n origin | grep Push | cut -d: -f2- | cut -d/ -f5-) &&
        printf "\n>${REPO}\n"
    if [ "$BRANCH" != master ]; then
        git stash &&
            git co master -q &&
            printf "Switched to master.\n"
        git pull &&
            git co ${BRANCH} -q &&
            printf "Switched back to $BRANCH.\n"
        git stash pop &&
            if $MERGE; then
                git merge master
            fi
    else
        git pull
    fi
}

for arg in "$@"; do
    case $arg in
    -m | --merge)
        MERGE=true
        shift
        ;;
    *)
        shift
        ;;
    esac
done

for i in "${DIRS[@]}"; do
    pull $i
done

printf "\n"
