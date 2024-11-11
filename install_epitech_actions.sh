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

print_message "Do you want to install a github protection when pushing ? (y/n)"
read response

if [ "$response" = "y" ]; then
    # Is Github CLI is installed
    if ! command -v gh &> /dev/null; then
        print_message "GitHub CLI (gh) is not installed on your device. Installing..."
        if [ "$(uname)" == "Darwin" ]; then
            brew install gh
        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            type curl >/dev/null 2>&1 || { sudo apt-get update && sudo apt-get install -y curl; }
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install gh
        fi
    fi

    # Authentificate with login web browser
    if ! gh auth status &> /dev/null; then
        print_message "Starting the authentification..."
        print_message "A window in your browser will open..."
        gh auth login --web
    fi

    # Get all informations needed
    REPO_URL=$(git config --get remote.origin.url)
    REPO_OWNER=$(echo $REPO_URL | awk -F'[/:]' '{print $(NF-1)}')
    REPO_NAME=$(echo $REPO_URL | awk -F'[/:]' '{print $NF}' | sed 's/.git$//')

    # Configuring the protection
    print_message "Configuring the protection minimal..."
    gh api \
      --method PUT \
      -H "Accept: application/vnd.github+json" \
      "/repos/$REPO_OWNER/$REPO_NAME/branches/main/protection" \
      -f required_status_checks='{"strict":false,"contexts":["style_check","test"]}' \
      -f enforce_admins=false \
      -f allow_force_pushes=true \
      -f allow_deletions=true \
      -f required_pull_request_reviews=null \
      -f restrictions=null

    if [ $? -eq 0 ]; then
        print_message "Success! Your protection as been installed correctly"
        print_message "Pushes will be blocked only if tests fail."
    else
        print_message "Error! There is an error during the installation, try creating the branch protection manually in the repo's settings."
    fi
fi

print_message "Starting the download of the github actions..."
git clone https://github.com/matteoepitech/EpitechActions.git /tmp/epitech-actions-github
print_message "Adding the workflow in this github..."
cp -r /tmp/epitech-actions-github/.github "$REPO_PATH/.github"
print_message "Cleaning up the useless files..."
rm -rf /tmp/epitech-actions-github/
print_message "The Epitech Actions Workflows is implemented in $REPO_PATH."
print_message "Success!"
