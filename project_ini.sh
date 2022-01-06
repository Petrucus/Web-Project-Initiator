#!/bin/bash -e # The -e flag instructs the script to exit on error

# The directory I choose to store all my SHA projects
directory_to_use="/c/Users/pesy/OneDrive/Documents/SHA_FE"

# The directory of the project itself
full_path="$directory_to_use/$1"

echo "Creating project $1 in $directory_to_use"

# Confirming everything looks good so far
read -p "Press enter to continue" gogo

# debug output
set -x

# folder creation
mkdir -p $full_path
mkdir -p $full_path/css
mkdir -p $full_path/js
mkdir -p $full_path/img
mkdir -p $full_path/fonts

# file creation
touch $full_path/index.html
touch $full_path/css/style.css
touch $full_path/js/script.js

# setting up index.html
cat << EOF > index.html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <link rel="icon" href="img/caticon.png">
        <link rel="stylesheet" href="/css/style.css" media="all">
        <title>$1</title>
    </head>
</html>
EOF

# adding in imgs + fonts
wget https://www.freefavicon.com/freefavicons/animal/cat--5-152-85909.png -O $full_path/img/caticon.png

echo "Project $1 folders have been created"

# use tree to display and confirm folder-file structure
tree $full_path || \
echo -e "try installing \e[4mtree\e[0m" && \
echo -e "using \e[4mapt-get install tree\e[0m in \e[4mLinux\e[0m" && \
echo -e "or downloading \e[4mhttp://downloads.sourceforge.net/gnuwin32/tree-1.5.2.2-bin.zip\e[0m in \e[4mWindows\e[0m" && \
echo -e "and moving it to \e[4mC:\Program Files\Git\usr\'bin'\e[0m"

# API POST call to github, to create a repo. Needs access token
# To create a token see: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
curl -X POST -u $github_access_token:x-oauth-basic https://api.github.com/user/repos -d "{\"name\":\"$1\"}"

# Setting up the repo README
echo "# $1" > $full_path/README.md
cd $full_path

# Initializing the repo locally
git init

# Adding, commiting and pushing the changes from local to remote
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Petrucus/$1.git
git push -u origin main
