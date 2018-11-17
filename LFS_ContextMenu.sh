#!/bin/sh

#####################
# LFS CONTEXT MENU	#
# BY FattyMieo		#
#					#
# VERSION: 1.2		#
# DATE: 05/10/2018	#
#####################

# Config
REPO_PATH=".."
SCRIPT_DIR="$(pwd)"
PROJECT_DIR="$( cd "$(dirname "../../")" ; pwd -P )"
PROJECT_NAME="$(basename "${PROJECT_DIR}")"
SENDTO_PATH="${APPDATA}/Microsoft/Windows/SendTo"
SHORTCUT_NAME="LFS_Drop Files Here.bat - Shortcut"

# Color Codes
RED='\033[1;31m'
DARKRED='\033[0;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NOCOLOR='\033[0m'

clear-inputs()
{
	while read -r -t 0; do read -r; done
}

title()
{
	echo -e "${YELLOW}\c"
	echo "=============================="
	echo "|  Context Menu for LFS-GUI  |"
	echo "=============================="
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
	clear-inputs
	read -n 1 -s -r -p "Press any key to continue..."
	exit
fi

#Cleanup if terminated
function finish {
	rm "${SENDTO_PATH}/LFS-GUI ($PROJECT_NAME).lnk"
}
trap finish EXIT

# Check if the shortcut exists
if [[ ! -e "${SCRIPT_DIR}/${SHORTCUT_NAME}.lnk" ]]
then
	echo "Unable to run this script."
	echo "Reason: \"${SHORTCUT_NAME}.lnk\" is not found."
	echo ""
	echo -e "${YELLOW}\c"
	echo "Installation:"
	echo -e "  1. Right-click ${MAGENTA}LFS_Drop Files Here.bat${YELLOW} and select ${MAGENTA}Create Shortcut${YELLOW}."
	echo -e "  2. Name the shortcut ${MAGENTA}\"${SHORTCUT_NAME}\"${YELLOW}."
	echo -e "${NOCOLOR}\c"
	echo ""
	clear-inputs
	read -n 1 -s -r -p "Press any key to exit..."
	exit
fi

title

echo -e "${CYAN}\c"
echo "Instruction:"
echo "  1. Select and Right-click files in the project."
echo -e "  2. Select ${MAGENTA}Send to -> LFS-GUI ($PROJECT_NAME)${CYAN}."
echo -e "  3. The selected files will be sent to ${MAGENTA}LFS_GUI${CYAN}."
echo -e "${NOCOLOR}\c"
echo ""
echo -e "${GREEN}The generated files will be automatically cleaned when exiting the program.${NOCOLOR}"
echo ""

echo -e "${YELLOW}Initializing ${MAGENTA}LFS_ContextMenu${YELLOW}...${NOCOLOR}"
cp "${SCRIPT_DIR}/${SHORTCUT_NAME}.lnk" "${SENDTO_PATH}/LFS-GUI ($PROJECT_NAME).lnk"

echo -e "${GREEN}[Context Menu] has started!${NOCOLOR}"
echo ""
clear-inputs
read -p "Press [Enter] key to close this program..."
