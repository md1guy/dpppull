#!/bin/bash

DIRS=("C:/DPPSource/dpp-platform-base" "C:/DPPSource/dpp8" "C:/DPPSource/dpp7")

MERGE=false
STASH=true

pull() {
    REPODIR=$1
    cd ${REPODIR}
    # BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    REPO=$(git remote show -n origin | grep Push | cut -d: -f2- | cut -d/ -f5-) &&
        printf "\n>${REPO}\n"
    if [ "$BRANCH" != master ]; then

        if $STASH; then
            git stash
        fi &&
            git checkout master -q &&
            printf "Switched to master.\n"
        git pull &&
            git checkout ${BRANCH} -q &&
            printf "Switched back to $BRANCH.\n"

        if $STASH; then
            git stash pop
        fi &&
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
    -ns | --nostash)
        STASH=false
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
