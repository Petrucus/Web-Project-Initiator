#!/bin/bash -e # The -e flag instructs the script to exit on error

# The directory I choose to store all my SHA projects
directory_to_use="/c/Users/pesy/OneDrive/Documents/SHA_FE"

echo "Is that a new project or are we just forking ?"
echo -e "1. New Project\n2. Fork\n"
read -p ":" answer

[[ answer -eq 1 ]] && { \

read -p "Project name: " project_name

# The directory of the project itself
full_path="$directory_to_use/$project_name"

echo "Creating project $project_name in $directory_to_use"

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
cat << EOF > $full_path/index.html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1.0">
        <link rel="icon" href="img/caticon.png">
        <link rel="stylesheet" href="/css/style.css" media="all">
        <title>$project_name</title>
    </head>
</html>
EOF

# adding in imgs + fonts
curl https://www.freefavicon.com/freefavicons/animal/cat--5-152-85909.png --output $full_path/img/caticon.png

echo "Project $project_name folders have been created"

# use tree to display and confirm folder-file structure
tree $full_path || \
echo -e "try installing \e[4mtree\e[0m" && \
echo -e "using \e[4mapt-get install tree\e[0m in \e[4mLinux\e[0m" && \
echo -e "or downloading \e[4mhttp://downloads.sourceforge.net/gnuwin32/tree-1.5.2.2-bin.zip\e[0m in \e[4mWindows\e[0m" && \
echo -e "and moving it to \e[4mC:\Program Files\Git\usr\'bin'\e[0m"

# API POST call to github, to create a repo. Needs access token
# To create a token see: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
# To read more about github api calls see: https://docs.github.com/en/rest/guides/getting-started-with-the-rest-api
curl -X POST -u $github_access_token:x-oauth-basic https://api.github.com/user/repos -d "{\"name\":\"$project_name\", \"private\": true}"

# Setting up the repo README
echo "# $project_name"|tr "_-" " " > $full_path/README.md
cd $full_path

# Initializing the repo locally
git init

# Adding, commiting and pushing the changes from local to remote
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/Petrucus/$project_name.git
git push -u origin main

}

[[ answer -eq 2 ]] && { \

read -p "Owner: " owner
read -p "Repo name: " repo_name

curl -X POST \
 -u $github_access_token:x-oauth-basic \
 -H "Accept: application/vnd.github.v3+json" \
 https://api.github.com/repos/$owner/$repo_name/forks
	
git clone https://github.com/Petrucus/$repo_name.git

} 

[[ !$? ]] && echo -e "\n1 or 2, make a call\n"