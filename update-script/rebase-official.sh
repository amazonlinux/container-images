#!/bin/bash
# Due to how much time has passed since the preflight steps and when the PR is created trying to merge local changes to master can cause merge conflicts. 
# This script is for quickly rebasing in case of merge conflicts when trying to push to master. 

# Set initial variables
git_directory="/home/ec2-user/official-images-output/official-images"
dockerhub_origin="git@github.com:docker-library/official-images.git"

# Set colors
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
purple="\033[1;35m"
cyan="\033[1;36m"
grey="\033[0;37m"
reset="\033[m"

# Take user input
while getopts u:r: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        r) release=${OPTARG};;
    esac
done

# Grab username
if [ -z "${username}" ];
then
	echo -e "${red}Missing username${reset}. ${green}Example: ./rebase-official.sh -u <username> -r <release>${reset}"
	exit 1
fi

# Grab release
if [ -z "${release}" ];
then
	echo -e "${red}Missing release version${reset}. ${green}Example: ./rebase-official.sh -u <username> -r <release>${reset}"
	exit 1
fi

# Set forked project
forked_repo="git@github.com:${username}/official-images.git"

# Ensure working directory
cd ${git_directory}

if [ $PWD = ${git_directory} ]
then
	echo -e "Current Directory is ${green}${PWD}${reset}"
else
	echo -e "${red}Unable to change directory to ${git_directory} Current Directory: ${PWD}${reset}"
	exit 1
fi

# Check remote url
git_remote=$(git remote get-url origin)

if [ ${git_remote} = ${dockerhub_origin} ];
then
	echo -e "${red}Remote url ${git_remote}is set incorrectly${reset}. ${green}Changing remote url to ${forked_repo}${reset}"
	git remote set-url origin ${forked_repo}
	status=$?

elif [ ${git_remote} = ${forked_repo} ];
then
	echo -e  "Verified remote is pointing to fork ${green}${forked_repo}${reset}"
	status="0"
fi

if [ ${status} = "0" ];
then
	echo -e "Creating and changing to new branch to store local changes. Using ${green}${release}${reset} id as branch name"
	git checkout -b ${release}

	echo -e "Changing branch back to ${green}master${reset}"
	git checkout master

	echo -e "Resetting ${blue}HEAD${reset} for ${green}master${reset} branch"
	git reset --hard origin/master

	echo -e "Pulling the latest changes from ${green}master${reset} branch"
	git pull

	echo -e "Change branch to ${green}${release}${reset}"
	git checkout ${release}

	echo -e "Rebase ${green}master${reset} branch"
	git rebase master

	echo -e "Push local changes to origin ${green}${release}${reset}"
	git push origin ${release}

	echo -e "Last step will be to create your Pull Request in GitHub from your feature branch: ${green}${release}${reset} into official-images/master."
	exit 0
fi
