#!/bin/bash

pull() {
    REPODIR=$1
    cd ${REPODIR} &&
        repo=$(git remote show -n origin | grep Push | cut -d: -f2- | cut -d/ -f5-) &&
        printf "\n>${repo}\n" &&
        br=$(git br | grep \* | cut -d ' ' -f2) &&
        git stash &&
        git co master &&
        git pull
    git co ${br} &&
        git stash apply
}

dirs=("C:/DPPSource/dpp-platform-base" "C:/DPPSource/dpp8" "C:/DPPSource/dpp7")

for i in "${dirs[@]}"; do
    pull $i
done

printf "\n"
read -n 1 -s -r -p "Press any key to continue..."
