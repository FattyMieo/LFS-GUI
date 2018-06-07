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
RED='\033[0;31m'
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

git_lfs_lock()
{
	echo -e "${RED}Locking ${MAGENTA}${1}${RED}...${NOCOLOR}"
	git lfs lock "./${1}"
}

git_lfs_unlock()
{
	echo -e "${GREEN}Unlocking ${MAGENTA}${1}${GREEN}...${NOCOLOR}"
	git lfs unlock "./${1}"
}

git_lfs_unlock_id()
{
	echo -e "${GREEN}Unlocking ID ${MAGENTA}${1}${GREEN}...${NOCOLOR}"
	git lfs unlock "--id=$id"
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
	
	git_lfs_lock "$actual_path"
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
		id="${input#--id=}"
		git_lfs_unlock_id "$id"
	else
		# Path Conversion
		actual_path="${input%\'}"				# Remove quote suffix
		actual_path="${actual_path#\'}"			# Remove quote prefix
		actual_path="${actual_path#./}"			# Remove any ./ prefix
		actual_path="${actual_path##$PWD/}"		# Remove PWD path
		
		git_lfs_unlock "$actual_path"
	fi
}

show_locks()
{
	echo "\$ git lfs locks"
	echo ""
	echo -e "${YELLOW}\c"
	echo "Loading locked files..."
	echo -e "${NOCOLOR}\c"
	echo ""
	echo "=========="
	echo ""
	git lfs locks
	echo ""
	echo "=========="
}

show_tracked()
{
	echo "\$ git lfs ls-files"
	echo ""
	echo -e "${YELLOW}\c"
	echo "Loading all tracked files in the project..."
	echo -e "${NOCOLOR}\c"
	echo ""
	echo "=========="
	echo ""
	git lfs ls-files
	echo ""
	echo "=========="
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
	
	if [ "$1" = "--windows" ]
	then
		path_type="windows"
		shift
	elif [ "$1" = "--posix" ]
	then
		path_type="posix"
		shift
	fi
	
	declare -a path_array # Declare an array externally
	count=0
	
	while [ "x${1}" != "x" ]
	do
		# Path Conversion
		if [ "$path_type" = "windows" ]
		then
			# Windows PATH to POSIX
			actual_path="${1%\"}"					# Remove quote suffix
			actual_path="${actual_path#\"}"			# Remove quote prefix
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
		
		path_array[$count]=$actual_path
		
		count=$(( $count + 1 ))
		shift
	done
	
	echo -e "${GREEN}LFS-GUI${NOCOLOR}: File Drag&Drop detected"
	echo ""
	
	exit=0
	while [ $exit = 0 ]
	do
		title
		
		echo "Files(s):" # Show relative path to file
		
		echo -e "${MAGENTA}\c"
		count=0
		while [ "x${path_array[count]}" != "x" ]
		do
			echo "${path_array[count]}"
			count=$(( $count + 1 ))
		done
		echo -e "${NOCOLOR}\c"
		
		#echo "File: ${1##*/}" # Show only filename
		echo ""
		echo -e "${CYAN}\c"
		echo "1. Lock"
		echo "2. Unlock"
		echo "3. View Locked Files"
		echo "4. View ALL Tracked Files"
		echo ""
		echo "0. Cancel"
		echo -e "${NOCOLOR}\c"
		echo ""
		read -e -p "\$ " input

		echo ""
		  if [ "$input" = 1 ]
		then
			count=0
			while [ "x${path_array[count]}" != "x" ]
			do
				git_lfs_lock "${path_array[count]}"
				count=$(( $count + 1 ))
			done
			
			exit=1
		elif [ "$input" = 2 ]
		then
			count=0
			while [ "x${path_array[count]}" != "x" ]
			do
				git_lfs_unlock "${path_array[count]}"
				count=$(( $count + 1 ))
			done
			
			exit=1
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
		
		if [ $exit = 1 ]
		then
			read -n 1 -s -r -p "Press any key to continue..."
		fi
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
	quick_action_menu "$@" # Pass in all arguments
else
	main_menu
fi
