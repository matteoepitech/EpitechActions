#!/bin/bash

print_message() {
    # ANSI Colors
    DARK_BLUE='\033[0;34m'
    LIGHT_BLUE='\033[0;36m'
    NC='\033[0m'
    
    echo -e "${DARK_BLUE}[${LIGHT_BLUE}EpitechActions${DARK_BLUE}]${NC} $1"
}

if [ -z "$1" ]; then
    print_message "Please specify the path of your github folder."
    print_message "Usage : ./install_epitech_actions.sh <path>"
    exit 1
fi

REPO_PATH="$1"
if [ ! -d "$REPO_PATH" ]; then
    print_message "This path is not a folder : $REPO_PATH"
    print_message "Did you spell it right ?"
    exit 1
fi

print_message "Starting the download of the github actions..."
git clone -q https://github.com/matteoepitech/EpitechActions.git /tmp/epitech-actions-github
print_message "Adding the workflow in this github..."
cp -r /tmp/epitech-actions-github/.github "$REPO_PATH/.github"
print_message "Cleaning up the useless files..."
rm -rf /tmp/epitech-actions-github/
print_message "The Epitech Actions Workflows is implemented in $REPO_PATH"
print_message "Success!"
