# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cd..='cd ..'

# kubectl and microk8s aliases
alias k='kubectl'
alias mk='microk8s kubectl'
alias m='microk8s'

# terraform alias
alias tf='terraform'
alias tff='terraform fmt -recursive'

alias sysup='sudo snap refresh && sudo apt update && sudo apt -y upgrade'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Set up JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# Add maven to path
export PATH=$PATH:/opt/apache-maven-3.8.6/bin

# Add gradle to path
export PATH=$PATH:/opt/gradle-7.5.1/bin

# Add xentry-aws-azure-login to path
export PATH=$PATH:/home/julian/.xentry-aws-azure-login

# Setup 256 color on terminal for k9s
export TERM=xterm-256color

# Add k9s to path
export PATH=$PATH:/opt/k9s

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add autocompletion to aws-cli
export PATH=$PATH:/usr/local/aws-cli/v2/2.7.15/bin/aws_completer

# Add go to path
export PATH=$PATH:/usr/local/go/bin

# Add lazygit to path
export PATH=$PATH:/home/julian/go/bin/

# Add GO install directory to path
export PATH=$PATH:/home/julian/go/bin/hello

# Function to make and change to dir in one step
mkchdir() {
	if [[ -d $1 ]]
	then
		echo directory $1 already exists
		return -1
	fi	
	mkdir $1
	cd $1
}

complete -C /usr/bin/terraform terraform
. "$HOME/.cargo/env"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

function aws-power-login {
  
  function find_profiles() {
    local search_str="$1"
    cat $HOME/.aws/config | grep "\[.*${search_str}.*\]" | sed -e 's/\[//' -e 's/\]//'
  }
  
  function show_commands() {
    echo "Available commands:"
    echo "1. Login all necessary accounts for profile"
    echo "2. Recreate kubeconfig for profile"
    echo "Q. Quit"
  }
  
  function exporting_profile() {
    export AWS_PROFILE=${profile}
  }
  
  function submenu() {
    local profile="$1"
    while true; do
      echo "Profile: $profile"
      show_commands
      read -p "Choose a command (1-2, or Q to quit): " command_choice
      case $command_choice in
        1)
          AWS_PROFILE="$profile" echo "login into genesis-network-tasp account"
                                 dt-aws-aad-sso login -p genesis-network-tasp > /dev/null 2>&1 
                                 echo "login into $profile account"
                                 dt-aws-aad-sso login -p $profile > /dev/null 2>&1
                                 echo "login into shared service docker and helm registry"
                                 aws ecr get-login-password --region eu-central-1 --profile $profile | \
                                 docker login --username AWS --password-stdin 621933005814.dkr.ecr.eu-central-1.amazonaws.com > /dev/null 2>&1
                                 aws ecr get-login-password --region eu-central-1 --profile $profile | \
                                 helm registry login --username AWS --password-stdin 621933005814.dkr.ecr.eu-central-1.amazonaws.com > /dev/null 2>&1
          ;;
        2)
          AWS_PROFILE="$profile" read -p "Enter cluster: " cluster_choice
                                 cluster=$(printf $profile | awk -F'-' '{print $NF}')
                                 #dt-aws-aad-sso login -p $profile -c $cluster > /dev/null 2>&1
                                 dt-aws-aad-sso login -p $profile -c $cluster_choice > /dev/null 2>&1
          ;;
    [Qq]*)
          echo "exporting AWS_PROFILE"
          exporting_profile
          break_out=true 
          break
          ;;
        *)
          echo "Invalid choice. Please try again."
          ;;
      esac
    done
  }
  
  function main_menu() {
    break_out=false    
    while [[ ${break_out} != "true" ]]; do
      read -p "Enter a search string (or Q to quit): " search_str
        if [[ "$search_str" =~ ^[Qq].* ]]; then
          break
        fi
      local profiles=( $(find_profiles "$search_str") )
        if [[ ${#profiles[@]} -eq 0 ]]; then
          echo "No matching profiles found. Please try again."
          continue
        fi
      echo "Matching profiles:"
        for i in "${!profiles[@]}"; do
          echo "$((i+1)). ${profiles[$i]}"
        done
      echo "Q. Quit"
      read -p "Choose a profile (1-${#profiles[@]}, or Q to quit): " profile_choice
        if [[ "$profile_choice" =~ ^[Qq].* ]]; then
          break_out=true
        elif ((profile_choice >= 1 && profile_choice <= ${#profiles[@]})); then
          submenu "${profiles[$((profile_choice-1))]}"
        else
          echo "Invalid choice. Please try again."
        fi
    done
  }
  
  main_menu
}

# bash parameter completion for the dotnet CLI

function _dotnet_bash_complete()
{
  local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n' # On Windows you may need to use use IFS=$'\r\n'
  local candidates

  read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2>/dev/null)

  read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
}

complete -f -F _dotnet_bash_complete dotnet

#Increase history file size
export HISTSIZE=10000
export HISTFILESIZE=10000

# Load Angular CLI autocompletion.
source <(ng completion script)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH

# pnpm
export PNPM_HOME="/home/julian/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Initialize Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

. "/home/julian/.deno/env"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
