#!/bin/bash

MERGE=false
DIRS=("C:/DPPSource/dpp-platform-base" "C:/DPPSource/dpp8" "C:/DPPSource/dpp7")

pull() {
    REPODIR=$1
    cd ${REPODIR}
    REPO=$(git remote show -n origin | grep Push | cut -d: -f2- | cut -d/ -f5-) &&
        printf "\n>${REPO}\n"
    git pull origin master &&
        if $MERGE; then
            git merge master
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
