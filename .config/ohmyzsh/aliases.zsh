#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH configurations and aliases.
#  Note:        Intended to be used in concert with Oh My Zsh
#               Create a file entitled 'aliases.zsh' in ~/.config/ohmyzsh/
#               For a full list of active aliases, run `alias`.
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Make Terminal Better (Remapping defaults and adding functionality)
#  2.  File & Folder management
#  3.  Process Management
#  4.  Searching
#  5.  Networking
#  6.  System Operations & Information
#  7.  Docker
#  8.  Git
#  9.  Misc
#  10. Reminders & Notes
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Make Terminal Better
#  --------------------------------------------------
    
    # General
    # ---------------
    alias ls='ls -G'                    # Preferred 'ls' implementation
    alias cp='cp -iv'                   # Preferred 'cp' implementation
    alias mv='mv -iv'                   # Preferred 'mv' implementation
    alias grep='grep --color=auto'      # Color grep
    alias mount='mount |column -t'      # Pretty and human readable mount
    alias mkdir='mkdir -pv'             # Preferred 'mkdir' implementation
    alias ll='ls -FGlAhp'               # Preferred 'll' implementation
    alias less='less -FSRXc'            # Preferred 'less' implementation
    alias f='open -a Finder ./'         # Opens current directory in MacOS Finder
    alias c='clear'                     # Clear terminal display
    alias path='echo -e ${PATH//:/\\n}' # Echo all executable Paths
    alias fix_stty='stty sane'          # Restore terminal settings when screwed up
    
    function trash () { 
      command mv "$@" ~/.Trash ;        # Moves a file to the trash
    }

    # Directories
    # ---------------
    function cd() {                   
      builtin cd "$@"; ll;              # Always list directory contents upon 'cd'
    } 

    alias ~="cd ~"                      # Go back to home
    alias .="cd .."                     # Go back 1 directory level
    alias ..="cd ../.."                 # Go back 2 directory levels
    alias ...="cd ../../.."             # Go back 3 directory levels
    alias ....="cd ../../../.."         # Go back 4 directory levels
    alias .....="cd ../../../../.."     # Go back 5 directory levels
      # OR #
    alias .1="cd .."                    # Go back 1 directory level
    alias .2="cd ../.."                 # Go back 2 directory levels
    alias .3="cd ../../.."              # Go back 3 directory levels
    alias .4="cd ../../../.."           # Go back 4 directory levels
    alias .5="cd ../../../../.."        # Go back 5 directory levels

    alias back='cd $OLDPWD'             # Go back to previous working directory

    function mcd () { 
      mkdir -p "$1" && cd "$1";         # Makes new directory and jumps inside
    }
    
    # Other
    # ---------------
    
    # Search manpage given in agument '1' for term given in argument '2' (case insensitive)
    # displays paginated result with colored search terms and two lines surrounding each hit.
    # Example: mans mplayer codec
    function mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

    # Remind yourself of an alias (given some part of it)
    function showa () { 
      /usr/bin/grep --color=always -i -a1 $@ ~/.config/ohmyzsh/aliases.zsh | grep -v '^\s*$' | less -FSRXc ; 
    }

#  --------------------------------------------------
#   2.  File & Folder Management
#  --------------------------------------------------
#
    alias filesize="stat -f \"%z bytes\""     # Get file size
    alias numFiles='echo $(ls -1 | wc -l)'    # Count of non-hidden files in current dir
    alias make1mb='mkfile 1m ./1MB.dat'       # Creates a file of 1mb size (all zeros)
    alias make5mb='mkfile 5m ./5MB.dat'       # Creates a file of 5mb size (all zeros)
    alias make10mb='mkfile 10m ./10MB.dat'    # Creates a file of 10mb size (all zeros)

    # Extract most known archives with one command
    function extract () {
      if [ -f $1 ] ; then
        case $1 in
          *.tar.bz2)   tar xjf $1     ;;
          *.tar.gz)    tar xzf $1     ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar e $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xf $1      ;;
          *.tbz2)      tar xjf $1     ;;
          *.tgz)       tar xzf $1     ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)     echo "'$1' cannot be extracted via extract()" ;;
            esac
      else
        echo "'$1' is not a valid file"
      fi
    }

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
    alias ttop="top -R -F -s 10 -o rsize"

    # List processes owned by my user
    function my_ps() { 
      ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; 
    }

    # Find out the pid of a specified process
    # Note that the command name can be specified via a regex
    # E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
    # Without the 'sudo' it will only find processes of the current user
    function findPid () { 
      lsof -t -c "$@" ; 
    }

#  --------------------------------------------------
#   4.  Searching
#  --------------------------------------------------
    
    # Quickly search for file
    alias qfind="find . -name "
    
    # Find file under the current directory
    function ff () { 
      /usr/bin/find . -name "$@" ;
    }       

    # Find file whose name starts with a given string
    function ffs () { 
      /usr/bin/find . -name "$@"'*' ;
    }   

    # Find file whose name ends with a given string
    function ffe () { 
      /usr/bin/find . -name '*'"$@" ;
    } 

    # Search for a file using MacOS Spotlight's metadata
    function spotlight () { 
      mdfind "kMDItemDisplayName == '$@'wc"; 
    }

#  --------------------------------------------------
#   5.  Networking
#  --------------------------------------------------
    
    alias myip='dig +short myip.opendns.com @resolver1.opendns.com' # Public facing IP Address
    alias netCons='lsof -i'                                         # Show all open TCP/IP sockets
    alias flushDNS='dscacheutil -flushcache'                        # Flush out the DNS Cache
    alias lsock='sudo /usr/sbin/lsof -i -P'                         # Display open sockets
    alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'               # Display only open UDP sockets
    alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'               # Display only open TCP sockets
    alias ipInfo0='ipconfig getpacket en0'                          # Get info on connections for en0
    alias ipInfo1='ipconfig getpacket en1'                          # Get info on connections for en1
    alias openPorts='sudo lsof -i | grep LISTEN'                    # All listening connections
    alias ping="ping -c 5"                                          # Stop after 5 pings

    # Unshorten link
    function unshort {                                             
        readonly link=${1:?"The shortened link must be specified."}
        curl -k -v -I "$link" 2>&1 | grep -i "< location" | cut -d " " -f 3
    }

    # Display useful host related informaton
    function ii() {
      echo -e "\nYou are logged on $HOST"
      echo -e "\nAdditionnal information:$NC " ; uname -a
      echo -e "\nUsers logged on:$NC " ; w -h
      echo -e "\nCurrent date:$NC " ; date
      echo -e "\nMachine stats:$NC " ; uptime
      echo -e "\nCurrent network location:$NC " ; scselect
      echo -e "\nPublic facing IP Address:$NC " ; myip
      echo
    }

    # Start an HTTP server from a directory, optionally specifying the port
    function server() {
      local port="${1:-8000}"
      open "http://localhost:${port}/"
      # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
      # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
      python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
    }

#  --------------------------------------------------
#   6.  System Operations & Information
#  --------------------------------------------------

    # For use when booted into single-user
    alias mountReadWrite='/sbin/mount -uw /'

    # Recursively delete .DS_Store files
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

    # Show hidden files in Finder
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'

    # Hide hidden files in Finder
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

    # Clean up LaunchServices to remove duplicates in the "Open With" menu
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#  --------------------------------------------------
#   7.  Docker
#  --------------------------------------------------
    
    # Drop into an interactive shell with bash
    function dockershell() {
      docker run --rm -i -t --entrypoint=/bin/bash "$@"
    }

    # Drop into an interactive shell with sh
    function dockershellsh() {
        docker run --rm -i -t --entrypoint=/bin/sh "$@"
    }

    # Drop into an interactive shell with bash and mount current working directory inside
    function dockershellhere() {
        dirname=${PWD##*/}
        docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
    }

    # Drop into an interactive shell with sh and mount current working directory inside
    function dockershellshhere() {
        docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
    }

    # For Pentesting
    # ---------------
    
    # Run any Impacket example just by typing "impacket"
    # E.g. impacket wmiexec.py lab.example.com/user@192.168.1.1
    function impacket() {
        docker run --rm -it f1rstm4tter/impacket "$@"
    }
    #  Mount the current directory into /tmp/serve and then 
    #  use Impacket’s smbserver.py to create a share at that directory
    function smbservehere() {
        local sharename
        [[ -z $1 ]] && sharename="SHARE" || sharename=$1
        docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" f1rstm4tter/impacket smbserver.py -smb2support $sharename /tmp/serve
    }

    # Run this in a directory to serve it over 80 and 443
    function nginxhere() {
        docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" f1rstm4tter/nginxserve
    }

    # Mount whatever files you want to share 
    # into /srv/data/share and expose it on port 80
    function webdavhere() {
        docker run --rm -it -p 80:80 -v "${PWD}:/srv/data/share" f1rstm4tter/webdav
    }

    # Run Metasploit and mount ~/.msf4 directory that gets shared across every instance
    function metasploit() {
        docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole "$@"
    }

    # Same above except forward every port from 8443-8500 when metasploit is launched. 
    # As long as a listener is set somewhere in that range - you can catch it
    function metasploitports() {
        docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework ./msfconsole "$@"
    }

    # Run the msfvenom command and save the payload
    # E.g. msfvenomhere -a x86 --platform windows -p windows/messagebox TEXT="pwned" -f dll -o /data/pwned.dll
    function msfvenomhere() {
        docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -v "${PWD}:/data" metasploitframework/metasploit-framework ./msfvenom "$@"
    }

    # Simple JavaScript server that echos any HTTP request it receives it to stdout
    # This starts a local listener on 80
    function reqdump() {
        docker run --rm -it -p 80:3000 f1rstm4tter/reqdump
    }

    # Purpose-built Docker image starts a webserver that 
    # accepts any file POST’ed to it and saves it to disk
    function postfiledumphere() {
        docker run --rm -it -p80:3000 -v "${PWD}:/data" f1rstm4tter/postfiledump
    }

#  --------------------------------------------------
#   8.  Git
#  --------------------------------------------------

    # Updating multiple repos with one command
    alias git-pull-all='find . -type d -name .git -exec sh -c "cd \"{}\"/../ && pwd && git pull" \;'

    # Aliases for common git commands
    alias g='git'
    alias gst='git status'
    alias gco='git checkout'
    alias gcob='git checkout -b'
    alias gcm='git commit -m'
    alias gamend='git commit -a --amend'
    alias gdeletemerged='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'

#  --------------------------------------------------
#   9.  Misc
#  --------------------------------------------------
    
    # Reset GPG to support SSH authentication via Yubikey
    alias gpgreset="gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye"

    # Get the weather
    alias weather='curl wttr.in/philadelphia,pa'

#  --------------------------------------------------
#   10.  Reminders & Notes
#  --------------------------------------------------