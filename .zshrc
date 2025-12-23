#  ---------------------------------------------------------------------------
#  Description: This file deploys important ZSH and Oh My Zsh configs.
#  Note:        To be placed in the $HOME directory.
#  ---------------------------------------------------------------------------

# Path to your oh-my-zsh installation.
ZSH="$HOME/.oh-my-zsh"

# Set to empty since we override the prompt below
ZSH_THEME=""

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Enable lazy loading nvm
export NVM_LAZY_LOAD="true"
export NVM_COMPLETION="true"

# Plugins
plugins=(zsh-nvm git extract urltools encode64)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Cache brew prefix for faster startup
BREW_PREFIX=$(brew --prefix)

# Load zsh plugins from Homebrew
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Autosuggestion style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

# History substring search keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# iTerm2 integration
source ${HOME}/.iterm2_shell_integration.zsh

# Prompt
export NEWLINE=$'\n'
export PS1='${NEWLINE}%F{8}${(l.$(afmagic_dashes)..-.)}%F{10}%D{%H:%M:%S%p} %F{7}%3~$(git_prompt_info)$(hg_prompt_info)${NEWLINE}%F{8}${(l.$(afmagic_dashes)..-.)}%F{8}» %f'
export PS2='%F{9}%{%}\ %f'
export RPS1='%F{9}%(?..%{%}%? ↵%{%})$(virtualenv_prompt_info) %F{8}%{%}%n@%m%{%} %f'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
