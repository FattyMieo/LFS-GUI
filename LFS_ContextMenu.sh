#!/bin/sh

#####################
# LFS CONTEXT MENU	#
# BY FattyMieo		#
#					#
# VERSION: 1.0		#
# DATE: 04/10/2018	#
#####################

# Config
REPO_PATH=".."
PROJECT_DIR="$( cd "$(dirname "../../")" ; pwd -P )"
PROJECT_NAME="$(basename "${PROJECT_DIR}")"
SENDTO_PATH="${APPDATA}/Microsoft/Windows/SendTo"
SHORTCUT_NAME="LFS_GUI_Shortcut"

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
	read -n 1 -s -r -p "Press any key to continue..."
	exit
fi

#Cleanup if terminated
function finish {
	rm "${SENDTO_PATH}/LFS-GUI ($PROJECT_NAME).lnk"
}
trap finish EXIT

title

# Check if the shortcut exists
if [[ ! -e "${SHORTCUT_NAME}.lnk" ]]
then
	echo -e "${RED}[WARNING] ${SHORTCUT_NAME}.lnk is missing and/or cannot be found!${NOCOLOR}"
	echo -e "${RED}[WARNING] Without the file, the program cannot function properly.${NOCOLOR}"
	echo ""
	read -n 1 -s -r -p "Press any key to exit..."
	exit
fi

echo -e "${YELLOW}\c"
echo "Installation:"
echo -e "  1. Find existing ${MAGENTA}${SHORTCUT_NAME}.lnk${YELLOW} or create a new shortcut named ${MAGENTA}${SHORTCUT_NAME}.lnk${YELLOW}."
echo -e "  2. Set the destination of the shortcut to ${MAGENTA}LFS_Drop Files Here.bat${YELLOW}."
echo -e "${NOCOLOR}\c"
echo ""

echo -e "${CYAN}\c"
echo "Instruction:"
echo "  1. Select and Right-click files in the project."
echo -e "  2. Select ${MAGENTA}Send to -> LFS-GUI ($PROJECT_NAME)${CYAN}."
echo -e "  3. The selected files will be sent to ${MAGENTA}LFS_GUI${CYAN}."
echo -e "${NOCOLOR}\c"
echo ""
echo -e "${GREEN}The generated files will be automatically cleaned when exiting the program.${NOCOLOR}"
echo ""
read -n 1 -s -r -p "Press any key to begin..."
echo ""
echo ""

echo -e "${YELLOW}Initializing ${MAGENTA}LFS_ContextMenu${YELLOW}...${NOCOLOR}"
cp "./${SHORTCUT_NAME}.lnk" "${SENDTO_PATH}/LFS-GUI ($PROJECT_NAME).lnk"

echo -e "${GREEN}[Context Menu] has started!${NOCOLOR}"
read -p "Press [Enter] key to close this program..."
