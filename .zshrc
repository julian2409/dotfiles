export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# Add JBang to environment
alias j!=jbang
export PATH="$HOME/.jbang/bin:$PATH"

# Aliases
# ls
alias ll="ls -al"

# kubectl
alias -g k="kubectl"

alias nv="nvim"

autoload -Uz compinit
fpath=(~/.zsh/completion $fpath)
compinit -i

#kubectl autocompletion
autoload -Uz compinit
compinit
source <(kubectl completion zsh)

# Load Angular CLI autocompletion.
source <(ng completion script)

zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix

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

precmd() {
  update_git_branch
  PROMPT="%F{green}%n@%m%f:%F{33}%~%f$branch%# "
}

update_git_branch

PROMPT="%F{green}%n@%m%f:%F{33}%~%f$branch%# "

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
