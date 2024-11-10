#!/bin/bash

if [ -z "$1" ]; then
    echo "Please specify the path of your github folder."
    echo "Usage : ./install_epitech_actions.sh <path>"
    exit 1
fi

REPO_PATH="$1"

if [ ! -d "$REPO_PATH" ]; then
    echo "This path is not a folder : $REPO_PATH"
    echo "Did you spell it right ?"
    exit 1
fi

echo "Starting the download of the github actions..."
git clone https://github.com/matteoepitech/EpitechActions.git /tmp/epitech-actions-github

echo "Adding the workflow in this github..."
cp -r /tmp/epitech-actions-github/.github "$REPO_PATH/.github"

echo "Cleaning up the useless files..."
rm -rf /tmp/epitech-actions-github/

echo "The Epitech Actions Workflows are implemented in $REPO_PATH"
echo "Sucess!"
