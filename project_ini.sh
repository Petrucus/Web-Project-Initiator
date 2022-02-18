#!/bin/bash -e # The -e flag instructs the script to exit on error

# debug output, uncomment to use
set -x

function project_creator() {

    echo "Creating project $project_name in $directory_to_use"

    # confirming everything looks good so far
    read -p "Press enter to continue" gogo

    # folder creation
    mkdir -p $full_path
    mkdir -p $full_path/css
    mkdir -p $full_path/js
    mkdir -p $full_path/img
    mkdir -p $full_path/fonts
    mkdir -p $full_path/pages

    # file creation
    touch $full_path/index.html
    touch $full_path/css/style.css
    touch $full_path/js/script.js
    touch $full_path/robots.txt

    # setting up index.html
    cat << EOF > $full_path/index.html
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width,initial-scale=1.0">
            <meta name=description content="$project_name">
            <link rel="icon" href="img/caticon.png">
            <link rel="stylesheet" href="/css/style.css" media="all">
            <title>$(cat $project_name|tr "-_" " ")</title>
        </head>
    </html>
EOF

    # setting up robots.txt
    cat << EOF > $full_path/robots.txt
    # https://www.robotstxt.org/robotstxt.html
    User-agent: *
    Disallow:
EOF

    # setting up style.css
    cat << EOF > $full_path/css/style.css
    /* Extra small devices (phones, 600px and down) */
    @media only screen and (max-width: 600px) {...}

    /* Small devices (portrait tablets and large phones, 600px and up) */
    @media only screen and (min-width: 600px) {...}

    /* Medium devices (landscape tablets, 768px and up) */
    @media only screen and (min-width: 768px) {...}

    /* Large devices (laptops/desktops, 992px and up) */
    @media only screen and (min-width: 992px) {...}

    /* Extra large devices (large laptops and desktops, 1200px and up) */
    @media only screen and (min-width: 1200px) {...}
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
    # to create a token see: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
    # to read more about github api calls see: https://docs.github.com/en/rest/guides/getting-started-with-the-rest-api
    { [[ -n $github_access_token ]] && \ 
    curl -X POST -u $github_access_token:x-oauth-basic https://api.github.com/user/repos -d "{\"name\":\"$project_name\", \"private\": true}" ; } \
    || { echo "No github access token !\nPlease read comments on how you can setup one" && exit 66 ;} 

    # setting up the repo README
    echo "# $project_name"|tr "_-" " " > $full_path/README.md
    cd $full_path

    # initializing the repo locally
    git init

    # adding, commiting and pushing the changes from local to remote
    git add .
    git commit -m "first commit"
    git branch -M main
    git remote add origin https://github.com/Petrucus/$project_name.git
    git push -u origin main

}

function project_forker() {
    read -p "Owner: " owner
    read -p "Repo name: " repo_name

    echo -e "\n Forking project $repo_name \n"

    # confirming everything looks good so far
    read -p "Press enter to continue" gogo

    # API POST call to github, to fork repo. Needs access token
    curl -X POST \
    -u $github_access_token:x-oauth-basic \
    -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/repos/$owner/$repo_name/forks

    cd $directory_to_use

    echo "Cloning project $repo_name in $directory_to_use - $(pwd))"

    # confirming everything looks good so far
    read -p "Press enter to continue" gogo

    # cloning the repo to local
    git clone https://github.com/Petrucus/$repo_name.git

    echo -e "\nForking Complete\n\n"
    echo -e "Do you wish to create a project structure within the fork ? \n"
    echo -e "If YES, use all capitals. Otherwise just press return"
    read -p ":" project_within_fork
    [[ $project_within_fork -eq "YES" ]] && project_creator 

}

# the directory I choose to store all my SHA projects
directory_to_use="/home/admin/Documents/SHA_FE"

read -p "Project name: " project_name

# the directory of the project itself
full_path="$directory_to_use/$project_name"

echo "Is that a new project or are we just forking ?"
echo -e "1. New Project\n2. Fork\n"

# decision input 
read -p ":" answer

##### Creating a new project #####
[[ answer -eq 1 ]] && project_creator

##### Forking #####
[[ answer -eq 2 ]] && project_forker


# Checking if last commands exit code was NOT true
[[ !$? ]] && echo -e "\n1 or 2, make a call\n"
