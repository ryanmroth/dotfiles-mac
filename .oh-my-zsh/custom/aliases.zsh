#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH aliases.
#  Note:        Intended to be used in concert with Oh My Zsh
#               For a full list of active aliases, run 'alias'.
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Make Terminal Better (Remapping defaults and adding functionality)
#  2.  File & Folder management
#  3.  Process Management
#  4.  Networking
#  5.  System Operations & Information
#  6.  GPG
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Make Terminal Better
#  --------------------------------------------------

    # General
    # ---------------
    alias ls='lsd'                       # Preferred 'ls' implementation
    alias ll='lsd -lAh'                  # Preferred 'll' implementation
    alias cp='cp -iv'                    # Preferred 'cp' implementation
    alias mv='mv -iv'                    # Preferred 'mv' implementation
    alias grep='grep --color=auto'       # Color grep
    alias mount='mount | column -t'      # Pretty and human readable mount
    alias mkdir='mkdir -pv'              # Preferred 'mkdir' implementation
    alias less='less -FSRXc'             # Preferred 'less' implementation
    alias f='open -a Finder ./'          # Opens current directory in MacOS Finder
    alias c='clear'                      # Clear terminal display
    alias path='echo -e ${PATH//:/\\n}'  # Echo all executable Paths
    alias fix_stty='stty sane'           # Restore terminal settings when screwed up

    # Directories
    # ---------------
    alias .1='cd ..'
    alias .2='cd ../..'
    alias .3='cd ../../..'
    alias .4='cd ../../../..'
    alias .5='cd ../../../../..'
    alias back='cd $OLDPWD'

    # History
    # ---------------
    alias h='history'
    alias hl='history | less'
    alias hs='history | grep'
    alias hsi='history | grep -i'

#  --------------------------------------------------
#   2.  File & Folder Management
#  --------------------------------------------------

    alias filesize='stat -f \"%z bytes\"'
    alias numFiles='echo $(ls -1 | wc -l)'
    alias make1mb='mkfile 1m ./1MB.dat'
    alias make5mb='mkfile 5m ./5MB.dat'
    alias make10mb='mkfile 10m ./10MB.dat'

#  --------------------------------------------------
#   3.  Process Management
#  --------------------------------------------------

    # Find memory hogs
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

    # Find CPU hogs
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

    # Continual 'top' listing (every 10 seconds)
    alias topForever='top -l 9999999 -s 10 -o cpu'

    # Recommended 'top' invocation to minimize resources
    alias ttop='top -R -F -s 10 -o rsize'

#  --------------------------------------------------
#   4.  Networking
#  --------------------------------------------------

    alias myip='curl -s icanhazip.com'
    alias netCons='lsof -i'
    alias flushDNS='dscacheutil -flushcache'
    alias lsock='sudo /usr/sbin/lsof -i -P'
    alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'
    alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'
    alias ipInfo0='ipconfig getpacket en0'
    alias ipInfo1='ipconfig getpacket en1'
    alias openPorts='sudo lsof -i | grep LISTEN'

#  --------------------------------------------------
#   5.  System Operations & Information
#  --------------------------------------------------

    alias mountReadWrite='/sbin/mount -uw /'
    alias cleanupDS='fd -H -t f "\.DS_Store$" -x rm'
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'
    alias cleanupLS='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'

#  --------------------------------------------------
#   6.  GPG
#  --------------------------------------------------

    alias gpgreset='gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye'
