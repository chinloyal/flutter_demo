#!/bin/bash

. "./.hooks/utils/log.sh"

BRANCH_PREFIX_REGEX='^(feature|hotfix|bugfix|refactor|release)/[.0-9a-z-]+$'
PROTECTED_BRANCHES_REGEX='^(master|develop)$'
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

validateBranchName () {
    if [[ ! $BRANCH_NAME =~ $PROTECTED_BRANCHES_REGEX && ! $BRANCH_NAME =~ $BRANCH_PREFIX_REGEX ]]; then
        error "Your branch is invalid, use the right naming convention."
        warn "Valid branch names start with feature/ | hotfix/ | bugfix/ | refactor/ |release/"
        warn "and end with the name of the thing you're working on"
        warn "(In alphanumeric lowercase characters a-z, 0-9 optionally separated by a dash)"
        warn "For example: feature/registration-validation."

        i "To rename your branch use this command:"
        i '`git branch -m my-SillyBranchname feature/name-of-feature`'

        exit 1
    fi
}

upToDate () {
    git fetch origin develop
    CURRENT_REMOTE_DEVELOP_HEAD=$(git rev-parse remotes/origin/develop)
    BRANCHES_WITH_ID=$(git branch --contains $CURRENT_REMOTE_DEVELOP_HEAD)
    ID_FOUND=false

    for ID in ${BRANCHES_WITH_ID[*]}; do
        if [[ $ID == $BRANCH_NAME ]]; then
            ID_FOUND=true
        fi
    done

    if [[ $ID_FOUND == true ]]; then
        success "Your branch is up to date with develop."
    else
        error "Your branch is not up to date with develop." 
        error "In order to push, you need to have the latest changes of the develop branch on your branch:" 
        error "Run 'git pull origin develop' and fix any potential merge conflicts." 
        error "Then try pushing again."
        exit 1
    fi

}

