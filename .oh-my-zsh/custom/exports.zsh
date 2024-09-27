#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH exports.
#  Note:        Intended to be used in concert with Oh My Zsh
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Prompt
#  2.  Language & Encoding
#  3.  Editor
#  4.  GPG
#  5.  Python
#  6.  Homebrew
#  7.  Paths
#  8.  Manpager
#  9.  Go
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Language & Encoding
#  --------------------------------------------------

    # Prefer US English and use UTF-8
    export LANG='en_US.UTF-8';
    export LC_ALL='en_US.UTF-8';

#  --------------------------------------------------
#   2.  Python
#  --------------------------------------------------

    # Make Python use UTF-8 encoding for output
    # to stdin, stdout, and stderr.
    export PYTHONIOENCODING='UTF-8';
 
#  --------------------------------------------------
#   3. Homebrew
#  --------------------------------------------------

    # Add Homebrew Github API
    export HOMEBREW_GITHUB_API_TOKEN=""
    # Tell homebrew to not autoupdate every single time I run it (just once a week).
    export HOMEBREW_AUTO_UPDATE_SECS=604800

#  --------------------------------------------------
#   4. Paths
#  --------------------------------------------------

    export PATH=""

#  --------------------------------------------------
#   5. Manpage
#  --------------------------------------------------

    # Don’t clear the screen after quitting a manual page.
    export MANPAGER='less -X';

#  --------------------------------------------------
#   6. Go
#  --------------------------------------------------

    export ASDF_GOLANG_MOD_VERSION_ENABLED='false'
    export GOPATH=$(go env GOPATH)
    export GOROOT=$(go env GOROOT)
    export GOBIN=$(go env GOBIN)
    export PATH=$PATH:$GOPATH/bin
    export PATH=$PATH:$GOROOT/bin
    export PATH=$PATH:$GOBIN


#  --------------------------------------------------
#   7. Editor
#  --------------------------------------------------

    # Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='nano'
    else
        export EDITOR='subl'
    fi

#  --------------------------------------------------
#   8.  GPG
#  --------------------------------------------------

    # GPG Agent and Authentication configuration for
    # Yubikey SSH setup
    GPG_TTY=$(tty)
    SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
    export GPG_TTY SSH_AUTH_SOCK
    gpgconf --launch gpg-agent
    gpg-connect-agent updatestartuptty /bye
