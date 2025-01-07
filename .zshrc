export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

# Aliases
#
# python3
alias -g python=python3

# ls
alias ll="ls -al"

# k8s
alias -g k="kubectl"
alias -g kn="kubens"
alias -g kc="kubectx"
alias -g mk='microk8s kubectl'
alias -g m='microk8s'

# terraform
alias -g tf="terraform"
alias -g tff='terraform fmt -recursive'
alias -g tfaa='terraform apply --auto-approve'

alias sysup="sudo snap refresh && sudo apt update && sudo apt -y upgrade"

alias vt="nmcli c show --active | grep Novatec && nmcli c down Novatec || nmcli c up Novatec"

alias -g nv="nvim"

alias q="quarkus"

# Set up JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add autocompletion to aws-cli
export PATH=$PATH:/usr/local/aws-cli/v2/2.7.15/bin/aws_completer

# Add go to path
export PATH=$PATH:/usr/local/go/bin

# Rust toolchain
. "$HOME/.cargo/env"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
 
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

# histfile setting
SAVEHIST=10000
HISTFILE=~/.zsh_history
HISTSIZE=5000
HISTFILESIZE=10000
setopt appendhistory
setopt share_history

autoload -Uz compinit
fpath=(~/.zsh/completion $fpath)
compinit -i

#kubectl autocompletion
autoload -Uz compinit
compinit source <(kubectl completion zsh)
source <(kubectl completion zsh)

# Load Angular CLI autocompletion.
source <(ng completion script)

zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

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

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

get_current_cluster() {
  local cluster
  ns=$(kubens -c)
  cluster=$(kubectl config current-context)
  if [ -n "$cluster" ]; then
    if [[ $cluster == */prod || $cluster == */toolchain-prod ]]; then
		echo -n " on %F{red}($cluster)%f::%F{cyan}($ns)%f"
    else
      echo -n " on %F{yellow}($cluster)%f::%F{cyan}($ns)%f"
    fi
  fi
}

get_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ "$branch" = "main" ]; then
      echo -n " on %F{red}($branch)%f"
    else
      echo -n " on %F{yellow}($branch)%f"
    fi
  fi
}

update_git_branch() {
  branch=$(get_git_branch)
}

update_cluster_status() {
  cluster=$(get_current_cluster)
}

precmd() {
  update_git_branch
  update_cluster_status
  PROMPT="%B%F{green}%n@%m%f:%F{33}%~%f%b$branch$cluster%# "
}

update_git_branch

PROMPT="%F{green}%n@%m%f:%F{33}%~%f$branch%# "

# bun completions
[ -s "/home/julian/.bun/_bun" ] && source "/home/julian/.bun/_bun"

# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

LS_COLORS=$LS_COLORS:'di=1;94:' ; export LS_COLORS

# tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  if [ "$TERMINAL_EMULATOR" != "JetBrains-JediTerm" ]; then
      exec tmux
  fi
fi

# GitHub CLI Workflow Run (gh workflow ru)
ghwr() {
    gh workflow run -r $(git symbolic-ref --short HEAD 2>/dev/null)
}

ghrw() {
    gh run watch
}

. "/home/julian/.deno/env"
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
