# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="random"
ZSH_THEME="random"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-syntax-highlighting)
#plugins=(git zsh-syntax-highlighting)
# http://github.com/zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern root line)
source /home/joe/Packages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/joe/Packages/zsh-autosuggestions/zsh-autosuggestions.zsh
export TERM=xterm-256color

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gvimt="gvim --remote-tab"
alias gvimr="gvim --remote"
alias xrandr-hdmi="xrandr --output HDMI1 --auto --right-of eDP1"
alias xrandr-hdmi-off="xrandr --output HDMI1 --off"
alias csLogin="ssh mcnu5088@wormulon.cs.uidaho.edu"
alias update="sudo apt-get update && sudo apt-get upgrade"
alias update-all="sudo apt-get update && sudo apt-get dist-upgrade"
alias clean-all="sudo apt-get autoremove"
alias i3logout="i3-msg exit"
#alias lock="lock.sh"
#alias i3lock="~/Misc/Packages/i3lock-blur/i3lock"
alias netflix="google-chrome --app='https://www.netflix.com'"
alias pysel="source ~/flowcontroller/virtual_ve/bin/activate"
alias pipsel="pip install ~/flowcontroller/flowcontroller/test/modules/testtools" 
alias git-branchname="git branch | grep \* | cut -d '/' -f2"

function t() {
  echo "telnet 192.168.1.240 30$1"
  telnet 192.168.1.240 "30$1"
}

agvim() {
  file=$(ag -l "$@" | rofi -dmenu -p "vim")
  if [ ! -z "$file" ]; then
    vim $file;
  else
    echo "No file chosen"
  fi
}

# games
alias minesweeper="freesweep"
alias tetris="tint"

# This disables zsh sessions from sharing their command history
setopt nosharehistory

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export EDITOR=/usr/bin/gvim # Change Gvim to default text editor. 

#opp.zsh
# source ~/Misc/Packages/opp.zsh/opp.zsh

#set -o vi
bindkey -v
export KEYTIMEOUT=1

# Add my custom scripts to the path
export PATH="$PATH:$HOME/Misc/custom-scripts/"
export PATH="$PATH:$HOME/Misc/custom-scripts/files/"
export PATH="$PATH:$HOME/.dotfiles/custom_scripts/"
export PATH="$PATH:$HOME/.dotfiles/custom_scripts/files/"

export WORKON_HOME=~/Envs
# source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

# add torch to path. torch directory is in ~/.torch/
# . /home/alexmcnurlin/.torch/install/bin/torch-activate

export GOPATH=$HOME/.Go

# Java installation
export JAVA_HOME=/home/alexmcnurlin/Misc/Packages/Java/jdk1.8.0_92/
export JRE_HOME=/home/alexmcnurlin/Misc/Packages/Java/jdk1.8.0_92/
export PATH=$PATH:/home/alexmcnurlin/Misc/Packages/Java/jdk1.8.0_92/bin:/home/alexmcnurlin/Misc/Packages/Java/jdk1.8.0_92/jre/bin

figlet -t "LinuxMasterRace"
#screenfetch

if [ -d "$HOME/.local/bin" ]; then
  export PATH=$PATH:$HOME/.local/bin/
  # export POWERLINE_CONFIG_COMMAND="$HOME/.local/bin/powerline-config"
fi
# . ~/.local/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh

# export PROMPT=$PROMPT"
# › "

# A calculator plugin for zsh
# source ~/.oh-my-zsh/custom/plugins/calc.plugin.zsh/calc.plugin.zsh

SAVEHIST=10000
HISTFILE=~/.zsh_history

# Settings for zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=7
bindkey '^N'  autosuggest-accept
bindkey '^P'  autosuggest-clear
bindkey '^\n' autosuggest-execute
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10000
export PATH="$PATH:$HOME/flowcontroller/alex_scripts"
