#!/bin/sh

#####################
# LFS FILE LOCK		#
# BY FattyMieo		#
#					#
# VERSION: 1.0		#
# DATE: 30/05/2018	#
#####################

# Config
REPO_PATH=".."

# Color Codes
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NOCOLOR='\033[0m'

title()
{
	echo -e "${YELLOW}\c"
	echo "=============================="
	echo "|      LFS File Locking      |"
	echo "=============================="
	echo -e "${NOCOLOR}\c"
	echo ""
}

lock_file()
{
	echo -e "${RED}\c"
	echo "=============================="
	echo "|        Locking File        |"
	echo "=============================="
	echo -e "${NOCOLOR}\c"
	echo ""
	echo -e "${CYAN}\c"
	echo "Tips: Drag the file into the windows to directly copy the path."
	echo "Type in the file's path:"
	echo -e "${NOCOLOR}\c"
	echo ""
	read -e -p "\$ git lfs lock " input
	echo ""
	
	# Path Conversion
	actual_path="${input%\'}"				# Remove quote suffix
	actual_path="${actual_path#\'}"			# Remove quote prefix
	actual_path="${actual_path#./}"			# Remove any . prefix
	actual_path="${actual_path##$PWD/}"		# Remove PWD path
	
	git lfs lock "./$actual_path"
}

unlock_file()
{
	echo -e "${GREEN}\c"
	echo "=============================="
	echo "|       Unlocking File       |"
	echo "=============================="
	echo -e "${NOCOLOR}\c"
	echo ""
	echo -e "${CYAN}\c"
	echo "Tips: Drag the file into the windows to directly copy the path."
	echo "Type in the file's path (or \"--id=<lock_id>\"):"
	echo -e "${NOCOLOR}\c"
	echo ""
	read -e -p "\$ git lfs unlock " input
	echo ""
	
	if [[ "$input" = --id=* ]]
	then
		git lfs unlock "$input"
	else
		# Path Conversion
		actual_path="${input%\'}"				# Remove quote suffix
		actual_path="${actual_path#\'}"			# Remove quote prefix
		actual_path="${actual_path#./}"			# Remove any ./ prefix
		actual_path="${actual_path##$PWD/}"		# Remove PWD path
		
		git lfs unlock "./$actual_path"
	fi
}

show_locks()
{
	echo "\$ git lfs locks"
	echo -e "${YELLOW}\c"
	echo "Loading locked files..."
	echo -e "${NOCOLOR}\c"
	echo ""
	git lfs locks
}

show_tracked()
{
	echo "\$ git lfs ls-files"
	echo -e "${YELLOW}\c"
	echo "Loading all tracked files in the project..."
	echo -e "${NOCOLOR}\c"
	echo ""
	git lfs ls-files
}

main_menu()
{
	exit=0
	while [ $exit = 0 ]
	do
		title
		
		echo -e "${CYAN}\c"
		echo "1. Lock a File"
		echo "2. Unlock a File"
		echo "3. View Locked Files"
		echo "4. View ALL Tracked Files"
		echo ""
		echo "0. Exit"
		echo -e "${NOCOLOR}\c"
		echo ""
		read -e -p "\$ " input

		echo ""
		  if [ "$input" = 1 ]
		then
			lock_file
		elif [ "$input" = 2 ]
		then
			unlock_file
		elif [ "$input" = 3 ]
		then
			show_locks
		elif [ "$input" = 4 ]
		then
			show_tracked
		elif [ "$input" = 0 ]
		then
			exit=1
			exit
		else
			$input
		fi
		
		echo ""
	done
}

quick_action_menu()
{
	if [ -z "$1" ]
	then
		return
	fi
	
	# Determine path type
	path_type="posix"
	
	if [ ! -z "$2" ]
	then
		if [ "$2" = "--windows" ]
		then
			path_type="windows"
		elif [ "$2" = "--posix" ]
		then
			path_type="posix"
		fi
	fi
	
	# Path Conversion
	if [ "$path_type" = "windows" ]
	then
		# Windows PATH to POSIX
		actual_path="${1//\\/\/}"				# Swap \ to /
		actual_path="${actual_path//:\//\/}"	# Swap :/ to /
		actual_path="/${actual_path,}"			# Add "/" and lowercase firts letter
		actual_path="${actual_path##$PWD/}"		# Remove PWD path
	elif [ "$path_type" = "posix" ]
	then
		# POSIX direct copy-paste
		actual_path="${1%\'}"					# Remove quote suffix
		actual_path="${actual_path#\'}"			# Remove quote prefix
		actual_path="${actual_path#./}"			# Remove any ./ prefix
		actual_path="${actual_path##$PWD/}"		# Remove PWD path
	else
		actual_path="${1}"
	fi
	
	exit=0
	while [ $exit = 0 ]
	do
		title
		
		echo -e "File: ${MAGENTA}${actual_path}${NOCOLOR}" # Show relative path to file
		#echo "File: ${1##*/}" # Show only filename
		echo ""
		echo -e "${CYAN}\c"
		echo "1. Lock"
		echo "2. Unlock"
		echo ""
		echo "0. Cancel"
		echo -e "${NOCOLOR}\c"
		echo ""
		read -e -p "\$ " input

		echo ""
		  if [ "$input" = 1 ]
		then
			git lfs lock "./$actual_path"
			exit=1
		elif [ "$input" = 2 ]
		then
			git lfs unlock "./$actual_path"
			exit=1
		elif [ "$input" = 0 ]
		then
			exit=1
			exit
		else
			$input
		fi
		
		echo ""
		read -n 1 -s -r -p "Press any key to continue..."
		echo ""
	done
}

# Run program
cd $REPO_PATH
if [ ! -d "$PWD/.git" ]
then
	echo "Unable to detect a git repository. (\".git\" not found)"
	echo "Tips: This script should be placed at the topmost level of the repository."
	echo ""
	read -n 1 -s -r -p "Press any key to continue..."
	exit
fi

if [ ! -z "$1" ]
then
	quick_action_menu "$1" "$2"
else
	main_menu
fi
