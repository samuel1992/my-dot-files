# Vi mode
bindkey -v
bindkey -M viins '^L' clear-screen
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M vicmd '^R' history-incremental-search-backward

# Zsh completions
autoload -Uz compinit && compinit 
source "$HOME/._zsh_docker_completion"

# Homebrew completion (if available)
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Git branch in prompt
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Prompt configuration (zsh uses PROMPT instead of PS1)
setopt PROMPT_SUBST
export PROMPT='%n@%m %F{green}%~%f%F{yellow}$(parse_git_branch)%f $ '

# History configuration
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh_history

# Custom environment variables
export LLPPATH=/Users/samuel/workspace/llp-local

# macOS defaults
defaults write com.todesktop.230313mzl4w4u92 ApplePressAndHoldEnabled -bool false

# Source custom scripts
source ~/.aikeys.sh
source ~/.sshclients.sh

# PATH additions
export PATH="$PATH:/Users/samuel/.local/bin"
# NOTE: The following lines are commented out for security.
# Create your own ~/.aikeys.sh and ~/.sshclients.sh files with your sensitive data.
# export PATH="$PATH:/opt/homebrew/bin"
# 
## Aliases

# Avante cli
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

# My workspace default folder
alias workspace='cd $HOME/workspace'
