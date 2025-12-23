#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH exports.
#  Note:        Intended to be used in concert with Oh My Zsh
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Language & Encoding
#  2.  Python
#  3.  Homebrew
#  4.  Paths
#  5.  Manpager
#  6.  Go
#  7.  Editor
#  8.  GPG
#  9.  Secrets
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Language & Encoding
#  --------------------------------------------------

    export LANG='en_US.UTF-8'
    export LC_COLLATE='en_US.UTF-8'

#  --------------------------------------------------
#   2.  Python
#  --------------------------------------------------

    export PYTHONIOENCODING='UTF-8'

#  --------------------------------------------------
#   3.  Homebrew
#  --------------------------------------------------

    # Only auto-update once a week
    export HOMEBREW_AUTO_UPDATE_SECS=604800

#  --------------------------------------------------
#   4.  Paths
#  --------------------------------------------------

    export PATH="$HOME/.asdf/shims:$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:/usr/local/bin:/usr/local/git/bin:/usr/local/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:/bin:/sbin:/usr/bin:/usr/sbin"

#  --------------------------------------------------
#   5.  Manpager
#  --------------------------------------------------

    export MANPAGER='less -X'

#  --------------------------------------------------
#   6.  Go
#  --------------------------------------------------

    # asdf manages Go, just need GOPATH for binaries
    export GOPATH="$HOME/go"
    export PATH="$PATH:$GOPATH/bin"

#  --------------------------------------------------
#   7.  Editor
#  --------------------------------------------------

    if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='nano'
    else
        export EDITOR='subl'
    fi

#  --------------------------------------------------
#   8.  GPG
#  --------------------------------------------------

    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"

    # Launch agent only if not already running
    if ! pgrep -x gpg-agent > /dev/null; then
        gpgconf --launch gpg-agent
    fi
    gpg-connect-agent updatestartuptty /bye > /dev/null 2>&1

#  --------------------------------------------------
#   9.  Secrets
#  --------------------------------------------------

    # Load secrets from separate file (not tracked in git)
    [[ -f "$HOME/.secrets" ]] && source "$HOME/.secrets"
