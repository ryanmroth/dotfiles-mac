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

  # Which plugins would you like to load?
  # Standard plugins can be found in $ZSH/plugins/
  # Custom plugins may be added to $ZSH_CUSTOM/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(git extract urltools)

  # Load Oh My Zsh
  source $ZSH/oh-my-zsh.sh

  # Load zsh-syntax-highlighting.
  source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Load zsh-autosuggestions.
  source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  # Enable autosuggestions automatically.
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

  # Load zsh-history-substring-search.
  source $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  # ITerm2 integration
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

  # Load asdf
  source $(brew --prefix asdf)/opt/asdf/libexec/asdf.sh
