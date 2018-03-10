#!/bin/sh
clear

# paths to important files
BASHRC=~/.bashrc # vars for interactive command line
PROFILE=~/.profile # vars NOT specificaly for bash, others can use

# colors for output print
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # no color


echo "${YELLOW}PACKAGE UPDATE...${NC}"
apt-get update


# ---curl---
echo "${GREEN}INSTALLING curl...${NC}"
apt-get install curl -y


# ---git---
echo "${GREEN}INSTALLING git...${NC}"
apt-get install git -y

# bash alias git -> g
COMMENT_LINE="# alias git -> g"
LINE="alias g='git'"

grep -qF -- "$COMMENT_LINE" "$BASHRC" || echo "$COMMENT_LINE" >> "$BASHRC"
grep -qF -- "$LINE" "$BASHRC" || echo "$LINE" >> "$BASHRC"

# git alias status -> st
git config --global alias.st status
# git alias commit -> cm
git config --global alias.cm commit
# git alias add -> a
git config --global alias.a add
# git alias rebase -> rb
git config --global alias.rb rebase
# git alias branch -> br
git config --global alias.br branch
# git alias checkout -> ch
git config --global alias.ch checkout


# ---ZSH SHELL---
echo "${GREEN}INSTALLING zsh_shell...${NC}"
apt-get install zsh -y
# set zsh as default shell
# by adding code to ~/.bashrc (only if it hasn't already been added)
# code in ~/.bashrc runs on every terminal start
COMMENT_LINE="# setting ZSH for default bash"
EXPORT_LINE="export SHELL=/bin/zsh"
EXEC_LINE="exec /bin/zsh -l"

grep -qF -- "$COMMENT_LINE" "$BASHRC" || echo "$COMMENT_LINE" >> "$BASHRC"
grep -qF -- "$EXPORT_LINE" "$BASHRC" || echo "$EXPORT_LINE" >> "$BASHRC"
grep -qF -- "$EXEC_LINE" "$BASHRC" || echo "$EXEC_LINE" >> "$BASHRC"
# install oh-my-zsh
echo "${GREEN}INSTALLING oh-my-zsh...${NC}"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# ---JAVA---
# prompt user to choose if he needs JAVA packages
echo "${CYAN}Do you want a ${RED}JAVA ${CYAN}environment? [Y/n]${NC}"
read JAVA
if [ "$JAVA" = "y" ] || [ "$JAVA" = "Y" ]; then
	echo "${GREEN}INSTALLING JDK 1.8...${NC}"
	apt-get install default-jdk -y
	
	# find dir on path: /usr/lib/jvm with name matching: java-1.*.*-openjdk-* pattern and save its path to variable
	JAVA_PATH=$(find /usr/lib/jvm -iname "java-1.*.*-openjdk-*" -exec echo {} \;)
	# add it to ~/.bashrc
	COMMENT_LINE="# setting JAVA_HOME path"
	JAVA_PATH_LINE="export JAVA_HOME=\"${JAVA_PATH}\""

	grep -qF -- "$COMMENT_LINE" "$PROFILE" || echo "$COMMENT_LINE" >> "$PROFILE"
	grep -qF -- "$JAVA_PATH_LINE" "$PROFILE" || echo "$JAVA_PATH_LINE" >> "$PROFILE"

	# --MAVEN--
	echo "${GREEN}INSTALLING maven...${NC}"
	apt-get install maven -y

	# --GRADLE--
	echo "${GREEN}INSTALLING gradle...${NC}"
	add-apt-repository ppa:cwchien/gradle -y
	apt-get update
	apt-get install gradle -y
fi
