#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH exports.
#  Note:        Intended to be used in concert with Oh My Zsh
#               Create a file entitled 'aliases.zsh' in ~/.config/ohmyzsh/
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Language & Encoding
#  2.  Editor
#  3.  GPG
#  4.  Python
#  5.  Homebrew
#  6.  Paths
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Language & Encoding
#  --------------------------------------------------

    # Prefer US English and use UTF-8
    export LANG='en_US.UTF-8';
    export LC_ALL='en_US.UTF-8';

#  --------------------------------------------------
#   2. Editor
#  --------------------------------------------------

    # Make Sublime default editor
    export EDITOR=subl

#  --------------------------------------------------
#   3.  GPG
#  --------------------------------------------------

    # GPG Agent and Authentication configuration for
    # Yubikey SSH setup
    GPG_TTY=$(tty)
    SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
    export GPG_TTY SSH_AUTH_SOCK
    gpgconf --launch gpg-agent
    gpg-connect-agent updatestartuptty /bye

#  --------------------------------------------------
#   4.  Python
#  --------------------------------------------------

    # Make Python use UTF-8 encoding for output
    # to stdin, stdout, and stderr.
    export PYTHONIOENCODING='UTF-8';
 
#  --------------------------------------------------
#   5. Homebrew
#  --------------------------------------------------

    # Add Homebrew Github API
    export HOMEBREW_GITHUB_API_TOKEN=""

#  --------------------------------------------------
#   6. Paths
#  --------------------------------------------------

    # Add Sublime and /usr/local/sbin to path
    export PATH="/usr/local/sbin:/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
