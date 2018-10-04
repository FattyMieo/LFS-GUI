#!/bin/sh

#####################
# LFS BULK UNLOCK	#
# BY FattyMieo		#
#					#
# VERSION: 1.0		#
# DATE: 04/10/2018	#
#####################

# Config
REPO_PATH=".."

# Color Codes
RED='\033[1;31m'
DARKRED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NOCOLOR='\033[0m'

title()
{
	echo -e "${YELLOW}\c"
	echo "==============================="
	echo "|      LFS Bulk Unlocker      |"
	echo "==============================="
	echo -e "${NOCOLOR}\c"
	echo ""
}

# Run program
cd $REPO_PATH
if [ ! -d "$PWD/.git" ]
then
	echo "Unable to detect a git repository. (\".git\" not found)"
	echo "Tips: This script should be placed in LFS-GUI folder located at the topmost level of the repository."
	echo ""
	read -n 1 -s -r -p "Press any key to continue..."
	exit
fi

#Cleanup if terminated
function finish { 
	rm ./locks.txt
}
trap finish EXIT

title

echo -e "${CYAN}\c"
echo "Insturctions:"
echo "  1. Edit locks.txt and remove all unwanted entries."
echo "  2. Save locks.txt and return to this window."
echo -e "${NOCOLOR}\c"
echo ""
read -n 1 -s -r -p "Press any key to begin..."
echo ""
echo ""

echo -e "${YELLOW}Generating list of locks into ${MAGENTA}locks.txt${YELLOW}...${NOCOLOR}"
git lfs locks >locks.txt
echo -e "${YELLOW}Opening ${MAGENTA}locks.txt${YELLOW}...${NOCOLOR}"
if start notepad++ # Prefer Notepad++
then
	start notepad++ locks.txt
else
	start "" locks.txt
fi

echo ""
echo -e "${GREEN}[Bulk Unlock] is ready!${NOCOLOR}"
read -p "Press [Enter] key to start..."
echo ""

echo "" >> locks.txt # Make sure there's at least an newline character in the file
while read p; do
	if [[ ! -z "${p}" ]]
	then
		echo -e "${GREEN}Unlocking ID ${MAGENTA}${p#*ID:}${GREEN}...${NOCOLOR}"
		git lfs unlock -i ${p#*ID:}
	fi
done <locks.txt
rm ./locks.txt
echo -e "${YELLOW}Removed ${MAGENTA}locks.txt${YELLOW}!${NOCOLOR}"
read -n 1 -s -r -p "Press any key to continue..."
