#  ---------------------------------------------------------------------------
#  Description: This file deploys important ZSH and Oh My Zsh configs.
#  Note:        To be placed in the $HOME directory.
#  ---------------------------------------------------------------------------

# -------------------------
# Oh My Zsh
# -------------------------
ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
COMPLETION_WAITING_DOTS="true"

# Lazy load nvm
export NVM_LAZY_LOAD="true"
export NVM_COMPLETION="true"

plugins=(zsh-nvm git extract urltools encode64)
source $ZSH/oh-my-zsh.sh

# -------------------------
# Homebrew plugins
# -------------------------
BREW_PREFIX=$(brew --prefix)
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# -------------------------
# Prompt
# -------------------------
setopt PROMPT_SUBST

_build_prompt() {
  PROMPT_DASHES="${(l:$((COLUMNS - 1))::-:)}"
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _build_prompt

PROMPT=$'\n%F{8}${PROMPT_DASHES} %F{10}%D{%H:%M:%S%p} %F{7}%3~$(git_prompt_info)$(hg_prompt_info)\n%F{8}${PROMPT_DASHES} %F{8}» %f'
RPROMPT='%F{9}%(?..%? ↵) $(virtualenv_prompt_info)%F{8}%n@%m%f'

# -------------------------
# PATH
# -------------------------
export PATH="$PATH:$HOME/.rvm/bin"
