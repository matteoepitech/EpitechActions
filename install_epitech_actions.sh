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

echo "Do you want to install a github protection when pushing ? (y/n)"
read response

if [ "$response" = "y" ]; then
    # Is Github CLI is installed
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed on your device. Installing..."
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
        echo "Starting the authentification..."
        echo "A window in your browser will open..."
        gh auth login --web
    fi

    # Get all informations needed
    REPO_URL=$(git config --get remote.origin.url)
    REPO_OWNER=$(echo $REPO_URL | awk -F'[/:]' '{print $(NF-1)}')
    REPO_NAME=$(echo $REPO_URL | awk -F'[/:]' '{print $NF}' | sed 's/.git$//')

    # Configuring the protection
    echo "Configuring the protection minimal..."
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
        echo "Success! Your protection as been installed correctly"
        echo "Pushes will be blocked only if tests fail."
    else
        echo "Error! There is an error during the installation, try creating the branch protection manually in the repo's settings."
    fi
fi

echo "Starting the download of the github actions..."
git clone https://github.com/matteoepitech/EpitechActions.git /tmp/epitech-actions-github

echo "Adding the workflow in this github..."
cp -r /tmp/epitech-actions-github/.github "$REPO_PATH/.github"

echo "Cleaning up the useless files..."
rm -rf /tmp/epitech-actions-github/

echo "The Epitech Actions Workflows is implemented in $REPO_PATH."
echo "Sucess!"
