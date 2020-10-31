#!/bin/bash

NODEJS_VERSION=12
SLACK_VERSION=4.4.2
INSTALL_WINE=YES
INSTALL_SKYPE=YES
TERRAFORM_VERSION=0.12.26

NOTE="# Added by Ubutnu-Fresh-Setup: https://github.com/plamendp/ubuntu-fresh-setup"


if [ -f "/tmp/ubuntu-fresh-setup.lock" ]; then 
   echo "Lock file found: /tmp/ubuntu-fresh-setup.lock"
   echo "It seems you already executed this script before."
   echo "Running it again may ruin your setup."
   echo "Check the system manually OR remove /tmp/ubuntu-fresh-setup.lock and try again."
   exit;
fi

touch "/tmp/ubuntu-fresh-setup.lock"


sudo dpkg --add-architecture i386
sudo apt update
apt-get -y upgrade


# ###################################################################
# Set timezone
dpkg-reconfigure tzdata


# ###################################################################
# Required by some packages and package management itself
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common 

# ###################################################################
# Various tools/utils 
sudo apt install -y \
	gparted vim mc synaptic iputils-ping \
	inetutils-traceroute dconf-editor net-tools findutils \
	lynx alacarte htop \
	build-essential file

# ###################################################################
# Wine
if [[ "${INSTALL_WINE}" == "YES" ]]; then
  sudo apt install -y wine64 wine32
fi

# ###################################################################
# nodejs
curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
sudo apt-get install -y nodejs

# ###################################################################
# npm (cli)
sudo apt install npm

# ###################################################################
# Homebrew (cli)
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo eval" ($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval $($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# ###################################################################
# docker (this will install docker.io as a dependancy)
# As of Ubuntu 20.04 docker.io package is more up to date
sudo apt install -y docker-compose
# Add current user to docker group (require logout and login, better system reboot)
sudo usermod -aG docker $USER

# ###################################################################
# Sublime
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt update
sudo apt install -y sublime-text

# ###################################################################
# Git (cli)
sudo apt-get install git

# ###################################################################
# Smartgit
curl -fsSL https://www.syntevo.com/downloads/smartgit/smartgit-20_1_1.deb > /tmp/smartgit.deb
sudo dpkg -i /tmp/smartgit.deb

# ###################################################################
# Postman
sudo snap install postman

# ###################################################################
# Slack
curl -fsSL https://downloads.slack-edge.com/linux_releases/slack-desktop-${SLACK_VERSION}-amd64.deb > /tmp/slack.deb
sudo apt install -y /tmp/slack.deb

# ###################################################################
# Gnome tweak
sudo apt install -y gnome-tweak-tool

# ###################################################################
# Java (OpenJDK)
sudo apt install -y default-jre

# ###################################################################
# AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
mv awscliv2.zip /tmp
unzip /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install

# ###################################################################
# Skype
if [[ "${INSTALL_SKYPE}" == "YES" ]]; then
  sudo snap install skype --classic
fi

# ###################################################################
# VLC
sudo apt install -y vlc

# ###################################################################
# SSH Server
sudo apt install -y openssh-server

# ###################################################################
# Terraform
curl -fsSL https://releases.hashicorp.com/terraform/"${TERRAFORM_VERSION}"/terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip > /tmp/terraform.zip \
  && sudo unzip -o /tmp/terraform.zip -d /usr/local/bin \
  && sudo chmod +x /usr/local/bin/terraform


sudo apt install -y -f



# ###################################################################
#
# Various configuration files
#
# ###################################################################

# ###################################################################
# VIM
cat << __T__ | sudo tee /etc/vim/vimrc.local
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set incsearch          " Incremental search
"set autowrite          " Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
"set mouse=a            " Enable mouse usage (all modes)
"set number
__T__

# ###################################################################
# Increase watch-files number (requires restart)
cat << __T__ | sudo tee -a /etc/sysctl.conf

$NOTE
# Because of projects having way too many files to watch (e.g. Angular)
fs.inotify.max_user_watches=524288
__T__

# ###################################################################
# NPM "global": we set npm global to be in the user home directory, .npm-global
cat << __T__ | tee ~/.npmrc
prefix=~/.npm-global
__T__

# ###################################################################
# NPM "global": add bin to PATH
cat << __T__ | tee -a ~/.profile

$NOTE
export PATH=~/.npm-global/bin:\$PATH
__T__

# ###################################################################
# Make "more/less" case insensitive and add that nice Midnight Commander alias/wrapper
cat << __T__ | sudo tee -a /etc/bash.bashrc

$NOTE
export LESS="-IR"
alias mc='. /usr/share/mc/bin/mc-wrapper.sh'
__T__

# ###################################################################
# Disable root over ssh and plain text password login (onlu non root and only with ssh keys)
cat << __T__ | sudo tee -a /etc/ssh/sshd_config.d/001-local.conf

$NOTE
PermitRootLogin no
PasswordAuthentication no
__T__

# ###################################################################
# SSH Client: avoid "too many auth failures" by setting a requirement an identitiy to be specified
cat << __T__ | sudo tee -a /etc/ssh/ssh_config.d/001-local.conf

$NOTE
IdentitiesOnly=yes
__T__
