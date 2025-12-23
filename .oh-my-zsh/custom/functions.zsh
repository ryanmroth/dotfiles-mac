#  ---------------------------------------------------------------------------
#  Description: This file holds all my ZSH functions.
#  Note:        Intended to be used in concert with Oh My Zsh
#  ---------------------------------------------------------------------------
#  Sections:
#  1.  Make Terminal Better (Remapping defaults and adding functionality)
#  2.  Process Management
#  3.  Searching
#  4.  Networking, Domain, Etc.
#  5.  Docker
#  6.  Pentesting
#  7.  System Management
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Make Terminal Better
#  --------------------------------------------------

    function trash () {
      command mv "$@" ~/.Trash
    }

    # Directories
    # ---------------

    function cd() {
      builtin cd "$@" || return
      if [[ $(ls -1 | wc -l) -lt 100 ]]; then
        ll
      else
        echo "($(ls -1 | wc -l) items)"
      fi
    }

    function mcd () {
      mkdir -p "$1" && cd "$1"
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
      /usr/bin/grep --color=always -i -a1 $@ ~/.oh-my-zsh/custom/aliases.zsh | grep -v '^\s*$' | less -FSRXc
    }

#  --------------------------------------------------
#   2.  Process Management
#  --------------------------------------------------

    # List processes owned by my user
    function my_ps() {
      ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command
    }

    # Find out the pid of a specified process
    # Note that the command name can be specified via a regex
    # E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
    # Without the 'sudo' it will only find processes of the current user
    function findPid () {
      lsof -t -c "$@"
    }

#  --------------------------------------------------
#   3.  Searching
#  --------------------------------------------------

    # Find file under the current directory (using fd)
    function ff () { fd "$@" ; }

    # Find file whose name starts with a given string
    function ffs () { fd "^$@" ; }

    # Find file whose name ends with a given string
    function ffe () { fd "$@\$" ; }

    # Search for a file using MacOS Spotlight's metadata
    function spotlight () {
      mdfind "kMDItemDisplayName == '*$@*'wc"
    }

#  --------------------------------------------------
#   4.  Networking, Domain, Etc.
#  --------------------------------------------------

    # Display useful host related informaton
    function ii() {
      local LABEL=$'\033[1;34m'
      local NC=$'\033[0m'
      local SEP=$'\033[0;90m────────────────────────────────────\033[0m'

      echo ""
      echo "${SEP}"
      printf "${LABEL}%-12s${NC} %s\n" "Host:" "${HOST}"
      printf "${LABEL}%-12s${NC} %s\n" "User:" "${USER}"
      echo "${SEP}"
      printf "${LABEL}%-12s${NC} %s\n" "System:" "$(uname -sr)"
      printf "${LABEL}%-12s${NC} %s\n" "Uptime:" "$(uptime | sed 's/.*up //' | sed 's/,.*//')"
      printf "${LABEL}%-12s${NC} %s\n" "Date:" "$(date '+%Y-%m-%d %H:%M:%S')"
      echo "${SEP}"
      printf "${LABEL}%-12s${NC} %s\n" "Network:" "$(scselect 2>&1 | grep '^ \*' | sed 's/.*(\(.*\))/\1/')"
      printf "${LABEL}%-12s${NC} %s\n" "Public IP:" "$(myip)"
      echo "${SEP}"
      echo ""
    }

    # Start an HTTP server from a directory, optionally specifying the port
    function server() {
      local port="${1:-8000}"
      python3 -m http.server "$port"
    }

    # Show all the names (CNs and SANs) listed in the SSL certificate for a given domain
    function getcertnames() {
      [[ -z "$1" ]] && { echo "Usage: getcertnames <domain>"; return 1; }

      echo "Checking $1..."
      echo | openssl s_client -connect "${1}:443" -servername "$1" 2>/dev/null \
        | openssl x509 -noout -text \
        | grep -E "(Subject:|DNS:)" \
        | sed 's/^\s*//'
    }

#  --------------------------------------------------
#   5.  Docker
#  --------------------------------------------------

    # Unified docker shell function
    # Usage:
    #   dshell bash image:tag        (shell into container with bash)
    #   dshell sh image:tag          (shell into container with sh)
    #   dshell bash here image:tag   (mount cwd and shell with bash)
    #   dshell sh here image:tag     (mount cwd and shell with sh)
    function dshell() {
      local shell="${1:-bash}"
      shift
      local args=("--rm" "-it" "--entrypoint=/bin/$shell")

      if [[ "$1" == "here" ]]; then
        local dirname=${PWD##*/}
        args+=("-v" "${PWD}:/${dirname}" "-w" "/${dirname}")
        shift
      fi

      docker run "${args[@]}" "$@"
    }

    # Convenience aliases for common patterns
    function dockershell()      { dshell bash "$@" ; }
    function dockershellsh()    { dshell sh "$@" ; }
    function dockershellhere()  { dshell bash here "$@" ; }
    function dockershellshhere() { dshell sh here "$@" ; }

    # Docker For Pentesting
    # ---------------

    # Run any Impacket example just by typing "impacket"
    # E.g. impacket wmiexec.py lab.example.com/user@192.168.1.1
    function impacket() {
      docker run --rm -it f1rstm4tter/impacket "$@"
    }

    # Mount the current directory into /tmp/serve and then
    # use Impacket's smbserver.py to create a share at that directory
    function smbservehere() {
      local sharename="${1:-SHARE}"
      docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" f1rstm4tter/impacket smbserver.py -smb2support $sharename /tmp/serve
    }

    # Run this in a directory to serve it over 80 and 443
    function nginxhere() {
      docker run --rm -it -p 80:80 -p 443:443 -v "${PWD}:/srv/data" f1rstm4tter/nginxserve
    }

    # Mount whatever files you want to share into /srv/data/share and expose it on port 80
    function webdavhere() {
      docker run --rm -it -p 80:80 -v "${PWD}:/srv/data/share" f1rstm4tter/webdav
    }

    # Run Metasploit and mount ~/.msf4 directory that gets shared across every instance
    function metasploit() {
      docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" metasploitframework/metasploit-framework ./msfconsole "$@"
    }

    # Same above except forward every port from 8443-8500 when metasploit is launched
    function metasploitports() {
      docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework ./msfconsole "$@"
    }

    # Run the msfvenom command and save the payload
    # E.g. msfvenomhere -a x86 --platform windows -p windows/messagebox TEXT="pwned" -f dll -o /data/pwned.dll
    function msfvenomhere() {
      docker run --rm -it -v "${HOME}/.msf4:/home/msf/.msf4" -v "${PWD}:/data" metasploitframework/metasploit-framework ./msfvenom "$@"
    }

    # Simple JavaScript server that echos any HTTP request it receives to stdout
    function reqdump() {
      docker run --rm -it -p 80:3000 f1rstm4tter/reqdump
    }

    # Webserver that accepts any file POST'ed to it and saves it to disk
    function postfiledumphere() {
      docker run --rm -it -p80:3000 -v "${PWD}:/data" f1rstm4tter/postfiledump
    }

    # MobSF Docker image
    function mobsf() {
      docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
    }

#  --------------------------------------------------
#   6.  Pentesting
#  --------------------------------------------------

    # Subdomain analysis
    function subanalyzer() {
      trap 'echo "\n[-] Interrupted"; return 130' INT

      if [[ -z "$1" ]]; then
        echo "Usage: subanalyzer <domain>"
        return 1
      fi

      local domain="$1"
      local results_dir="${domain}-results"

      echo "[+] Creating results directory: $results_dir"
      mkdir -p "$results_dir" || { echo "[-] Failed to create directory"; return 1; }

      echo "[+] Running subfinder for $domain..."
      subfinder -d "$domain" -silent -o "$results_dir/subdomains.txt" || {
        echo "[-] Subfinder failed"
        return 1
      }

      local subdomain_count=$(wc -l < "$results_dir/subdomains.txt")
      echo "[+] Found $subdomain_count subdomains"

      echo "[+] Checking alive subdomains with httpx..."
      httpx -l "$results_dir/subdomains.txt" \
            -threads 50 \
            -timeout 10 \
            -status-code \
            -title \
            -silent \
            -o "$results_dir/alive_subdomains.txt" || {
        echo "[-] httpx failed"
        return 1
      }

      local alive_count=$(wc -l < "$results_dir/alive_subdomains.txt")
      echo "[+] Found $alive_count alive subdomains"

      echo "[+] Cleaning URLs for screenshot capture..."
      awk '{print $1}' "$results_dir/alive_subdomains.txt" > "$results_dir/clean_urls.txt"

      echo "[+] Checking for .git files..."
      sed 's|$|/.git|' "$results_dir/clean_urls.txt" > "$results_dir/git_urls.txt"
      httpx -l "$results_dir/git_urls.txt" \
            -threads 30 \
            -timeout 5 \
            -status-code \
            -mc 200,403 \
            -silent \
            -o "$results_dir/git_found.txt" || {
        echo "[-] Git check failed"
        return 1
      }

      local git_count=$(wc -l < "$results_dir/git_found.txt" 2>/dev/null || echo "0")
      echo "[+] Found $git_count .git files"

      echo "[+] Taking screenshots with gowitness..."
      gowitness scan file \
               -f "$results_dir/clean_urls.txt" \
               --screenshot-format png \
               --chrome-window-x 1280 \
               --chrome-window-y 720 \
               -s "$results_dir/screenshots/" \
               -q || {
        echo "[-] gowitness failed"
        return 1
      }

      trap - INT

      echo "[+] Analysis complete! Results saved in $results_dir/"
      echo "    - Subdomains: $results_dir/subdomains.txt"
      echo "    - Alive hosts: $results_dir/alive_subdomains.txt"
      echo "    - Git files: $results_dir/git_found.txt"
      echo "    - Screenshots: $results_dir/screenshots/"
    }

#  --------------------------------------------------
#   7.  System Management
#  --------------------------------------------------

    function sysupdate() {
      local failed=()
      local start=$SECONDS

      run() {
        local step_start=$SECONDS
        echo "\n\033[1;34m→ $1\033[0m"
        if ! eval "$2"; then
          failed+=("$1")
        fi
        echo "\033[0;90m  ($(( SECONDS - step_start ))s)\033[0m"
      }

      run "brew update"       "brew update"
      run "brew upgrade"      "brew upgrade"
      run "brew cask upgrade" "brew upgrade --cask"
      run "brew cleanup"      "brew cleanup"
      run "brew doctor"       "brew doctor"
      run "brew missing"      "brew missing"
      run "tools update"      "(cd ~/Tools && ./update)"
      run "uv tools"          "uv tool upgrade --all"

      echo ""
      if (( ${#failed[@]} )); then
        echo "\033[1;31m✗ Failed: ${failed[*]}\033[0m"
        echo "\033[0;90mTotal: $(( SECONDS - start ))s\033[0m"
        return 1
      else
        echo "\033[1;32m✓ All updates complete\033[0m"
        echo "\033[0;90mTotal: $(( SECONDS - start ))s\033[0m"
      fi
    }
