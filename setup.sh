#!/bin/bash

# ###################################################################
# Virtual machines, Containers and Emulators
DOCKER=YES        # Docker      (https://www.docker.com/)
WINE=YES          # Wine        (https://www.winehq.org/)

# ###################################################################
# Package management
HOMEBREW=YES      # Homebrew    (https://brew.sh/)
NPM=YES           # npm         (https://www.npmjs.com/)

# ###################################################################
# Development environment

# ### Version control systems
GIT=YES           # Git         (https://git-scm.com/)
SMARTGIT=YES      # SmartGit    (https://www.syntevo.com/smartgit/)

# ### IDE and text editors
SUBLIME=YES       # Sublime     (https://www.sublimetext.com/)
WEBSTORM=YES      # WebStorm    (https://www.jetbrains.com/webstorm/)

# ### Web clients
CHROME=YES        # Chrome      (https://www.google.com/chrome/)
POSTMAN=YES       # Postman     (https://www.postman.com/)
AWS=YES           # AWS         (https://aws.amazon.com/cli/)
TERRAFORM=YES     # Terraform   (https://www.terraform.io/)
TERRAFORM_VERSION=0.12.26

# ### Web servers
OPEN_SSH=YES      # OpenSSH     (https://www.openssh.com/)

# ### Runtime environments

# ### ### JavaScript
NODEJS=YES        # Node.js     (https://nodejs.org/en/)
NODEJS_VERSION=12

# ### ### JAVA
OPEN_JDK=YES      # OpenJDK     (https://openjdk.java.net/)

# ###################################################################
# Communication tools
SLACK=YES         # Slack       (https://slack.com/)
SLACK_VERSION=4.4.2
SKYPE=YES         # Skype       (https://www.skype.com/)

# ###################################################################
# Miscellaneous
VLC=YES           # VLC player  (https://www.videolan.org/vlc/index.html)

# ###################################################################
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
sudo apt-get install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common

# ###################################################################
# Various tools/utils 
sudo apt install -y \
	gparted vim mc synaptic iputils-ping \
	inetutils-traceroute dconf-editor net-tools findutils \
	lynx alacarte htop \
	build-essential file

# ###################################################################
# Gnome tweak
sudo apt install -y gnome-tweak-tool
# ###################################################################
# ###################################################################
echo "Virtual machines and Emulators:"
# ###################################################################
if [[ "${DOCKER}" == "YES" ]]; then
  echo "installing Docker (https://www.docker.com/)"
  # this will install docker.io as a dependency
  sudo apt install -y docker-compose
  sudo usermod -aG docker $USER
else
  echo "skipping Docker (https://www.docker.com/) installation"
fi
if [[ "${WINE}" == "YES" ]]; then
  echo "installing Wine (https://www.winehq.org/)"
  sudo apt install -y wine64 wine32
else
  echo "skipping Wine (https://www.winehq.org/) installation"
fi
# ###################################################################
echo "Package management"
# ###################################################################
if [[ "${HOMEBREW}" == "YES" ]]; then
  echo "installing Homebrew (https://brew.sh/)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
  test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo eval" ($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval $($(brew --prefix)/bin/brew shellenv)" >>~/.bashrc
else
  echo "skipping Homebrew (https://brew.sh/) installation"
fi
if [[ "${NPM}" == "YES" ]]; then
  echo "installing npm (https://www.npmjs.com/)"
  sudo apt install npm
else
  echo "skipping npm (https://www.npmjs.com/) installation"
fi
# ###################################################################
echo "Development environment"
# ###################################################################

echo "* Version control systems:"
if [[ "${GIT}" == "YES" ]]; then
  echo "installing Git (https://git-scm.com/)"
  sudo apt-get install git
else
  echo "skipping Git (https://git-scm.com/) installation..."
fi
if [[ "${SMARTGIT}" == "YES" ]]; then
  echo "installing SmartGit (https://www.syntevo.com/smartgit/)"
  curl -fsSL https://www.syntevo.com/downloads/smartgit/smartgit-20_1_1.deb > /tmp/smartgit.deb
  sudo dpkg -i /tmp/smartgit.deb
else
  echo "skipping SmartGit (https://www.syntevo.com/smartgit/) installation"
fi

echo "* IDE and text editors"
if [[ "${SUBLIME}" == "YES" ]]; then
  echo "installing Sublime (https://www.sublimetext.com/)"
  curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add
  sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
  sudo apt update
  sudo apt install -y sublime-text
else
  echo "skipping Sublime (https://www.sublimetext.com/) installation"
fi
if [[ "${WEBSTORM}" == "YES" ]]; then
  echo "installing WebStorm (https://www.jetbrains.com/webstorm/)"
  sudo snap install webstorm --classic
else
  echo "skipping WebStorm (https://www.jetbrains.com/webstorm/) installation"
fi

echo "* Web clients"
if [[ "${CHROME}" == "YES" ]]; then
  echo "installing Chrome (https://www.google.com/chrome/)"
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb
else
  echo "skipping Chrome (https://www.google.com/chrome/) installation"
fi
if [[ "${POSTMAN}" == "YES" ]]; then
  echo "installing Postman (https://www.postman.com/)"
  sudo snap install postman
else
  echo "skipping Postman (https://www.postman.com/) installation"
fi
if [[ "${AWS}" == "YES" ]]; then
  echo "installing AWS cli (https://aws.amazon.com/cli/)"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  mv awscliv2.zip /tmp
  unzip /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
else
  echo "skipping AWS cli (https://aws.amazon.com/cli/)"
fi
if [[ "${TERRAFORM}" == "YES" ]]; then
  echo "installing Terraform (https://www.terraform.io/)"
  curl -fsSL https://releases.hashicorp.com/terraform/"${TERRAFORM_VERSION}"/terraform_"${TERRAFORM_VERSION}"_linux_amd64.zip > /tmp/terraform.zip \
  && sudo unzip -o /tmp/terraform.zip -d /usr/local/bin \
  && sudo chmod +x /usr/local/bin/terraform
else
  echo "skipping Terraform (https://www.terraform.io/)"
fi

echo " * Web servers"
if [[ "${OPEN_SSH}" == "YES" ]]; then
  echo "installing OpenSSH (https://openjdk.java.net/)"
  sudo apt install -y openssh-server
else
  echo "skipping OpenSSH (https://openjdk.java.net/)"
fi

# ###################################################################
echo " * Runtime environments"
# ###################################################################

echo " - JavaScript"
if [[ "${NODEJS}" == "YES" ]]; then
  echo "installing Node.js (https://nodejs.org/en/)"
  curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | sudo -E bash -
  sudo apt-get install -y nodejs
else
  echo "skipping Node.js (https://nodejs.org/en/) installation"
fi

echo " - Java"
if [[ "${OPEN_JDK}" == "YES" ]]; then
  echo "installing OpenJDK (https://openjdk.java.net/)"
  sudo apt install -y default-jre
else
  echo "skipping OpenJDK (https://openjdk.java.net/)"
fi

# ###################################################################
echo "Communication tools"
# ###################################################################
if [[ "${SLACK}" == "YES" ]]; then
  echo "installing Slack (https://slack.com/)"
  curl -fsSL https://downloads.slack-edge.com/linux_releases/slack-desktop-${SLACK_VERSION}-amd64.deb > /tmp/slack.deb
  sudo apt install -y /tmp/slack.deb
else
  echo "skipping Slack (https://slack.com/) installation"
fi
if [[ "${SKYPE}" == "YES" ]]; then
  echo "installing Skype (https://www.skype.com/)"
  sudo snap install skype --classic
else
  echo "skipping Skype (https://www.skype.com/) installation"
fi
# ###################################################################
echo " * Miscellaneous"
# ###################################################################
if [[ "${VLC}" == "YES" ]]; then
  echo "installing VLC player (https://www.videolan.org/vlc/index.html)"
  sudo apt install -y vlc
else
  echo "skipping VLC player (https://www.videolan.org/vlc/index.html)"
fi

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
