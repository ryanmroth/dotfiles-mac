#  ---------------------------------------------------------------------------
#  Description: This file deploys important ZSH and Oh My Zsh configs.
#  Note:        To be placed in the $HOME directory.
#  ---------------------------------------------------------------------------

  # Path to your oh-my-zsh installation.
  ZSH="$HOME/.oh-my-zsh"

  # Set name of the theme to load --- if set to "random", it will
  # load a random theme each time oh-my-zsh is loaded, in which case,
  # to know which specific one was loaded, run: echo $RANDOM_THEME
  # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
  ZSH_THEME="af-magic"

  # Display red dots whilst waiting for completion.
  COMPLETION_WAITING_DOTS="true"

  # Enable lazy loading nvm
  export NVM_LAZY_LOAD="true"
  export NVM_COMPLETION="true"

  # Which plugins would you like to load?
  # Standard plugins can be found in $ZSH/plugins/
  # Custom plugins may be added to $ZSH_CUSTOM/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(zsh-nvm git extract urltools)

  # Load Oh My Zsh
  source $ZSH/oh-my-zsh.sh

  # Load zsh-syntax-highlighting.
  source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # Load zsh-autosuggestions.
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  # Enable autosuggestions automatically.
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

  # Load zsh-history-substring-search.
  source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  # ITerm2 integration
  source ${HOME}/.iterm2_shell_integration.zsh

# Prompt
    export NEWLINE=$'\n'
  export PS1='${NEWLINE}%F{8}${(l.$(afmagic_dashes)..-.)}%F{10}%D{%H:%M:%S%p} %F{7}%3~$(git_prompt_info)$(hg_prompt_info)${NEWLINE}%F{8}${(l.$(afmagic_dashes)..-.)}%F{8}» %f'
  export PS2='%F{9}%{%}\ %f'
  export RPS1='%F{9}%(?..%{%}%? ↵%{%})$(virtualenv_prompt_info) %F{8}%{%}%n@%m%{%} %f'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Direnv
eval "$(direnv hook zsh)"
