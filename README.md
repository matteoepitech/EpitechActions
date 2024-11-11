# Epitech Actions
This workflow will build your unit tests and check the coding style in your repository when pushing any new changes.

# How to setup ?
1. Download the `install_epitech_actions.sh`
2. Go to the folder you just downloaded it
3. Do `chmod +x ./install_epitech_actions.sh` if you don't have the permission to execute it
4. Do `./install_epitech_actions.sh <path>` to install the workflow to the given path

# How to cancel commit on tests fails ? (Optional)
1. Go to your repository on Github
2. Click on `Settings` (tab with gear icon)
3. Select `Branches` in the left sidebar
4. Click `Add classic branch protection rule`
5. In *branch name pattern* type `main`
6. Check the option `Require status checks to pass before merging`
7. And select all the jobs you want to cancel the commit if failed
8. Leave all other options by default
9. Click `Create` at the bottom

Now Github will automatically cancel your commit if any tests failed (depends on what you put in the select search box before).

# Why no automatically process ?
In the script there was a automated process of installing your branch protection, but this was only for Github Pro users. I decided to remove it.

Enjoy! 💝
