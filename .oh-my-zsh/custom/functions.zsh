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
#  6.  Encoding
#  7.  Pentesting
#  8.  Misc
#  ---------------------------------------------------------------------------

#  --------------------------------------------------
#   1.  Make Terminal Better
#  --------------------------------------------------
    
    function trash () { 
      command mv "$@" ~/.Trash ;        # Moves a file to the trash
    }

    # Directories
    # ---------------
    
    function cd() {                   
      builtin cd "$@"; ll;              # Always list directory contents upon 'cd'
    }

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
#   2.  Process Management
#  --------------------------------------------------
 
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
#   3.  Searching
#  --------------------------------------------------

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
#   4.  Networking, Domain, Etc.
#  --------------------------------------------------
#
    # Unshorten link
    #function unshort {
    #    readonly link=${1:?"The shortened link must be specified."}
    #    curl -k -v -I "$link" 2>&1 | grep -i "< location" | cut -d " " -f 3
    #}

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
      python3 -m http.server "$port"
    }
    
    # Show all the names (CNs and SANs) listed in the SSL certificate
    # for a given domain
    function getcertnames() {
      if [ -z "${1}" ]; then
        echo "ERROR: No domain specified.";
        return 1;
	    fi;

      local domain="${1}";
      echo "Testing ${domain}…";
      echo ""; # newline

      local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
        | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

      if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" \
          | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
          no_serial, no_sigdump, no_signame, no_validity, no_version");
        echo "Common Name:";
        echo ""; # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
        echo ""; # newline
        echo "Subject Alternative Name(s):";
        echo ""; # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
          | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
        return 0;
      else
        echo "ERROR: Certificate not found.";
        return 1;
      fi;
    }

#  --------------------------------------------------
#   5.  Docker
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

    # Docker For Pentesting
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

    # MobSF Docker image
    function mobsf() {
      docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
    }

#  --------------------------------------------------
#   6.  Encoding
#  --------------------------------------------------
    
    function encode64() {
      if [[ $# -eq 0 ]]; then
        cat | base64
      else
        printf '%s' $1 | base64
      fi
    }

    function encodefile64() {
      if [[ $# -eq 0 ]]; then
        echo "You must provide a filename"
      else
        base64 -i $1 -o $1.txt
        echo "${1}'s content encoded in base64 and saved as ${1}.txt"
      fi
    }

    function decode64() {
      if [[ $# -eq 0 ]]; then
        cat | base64 --decode
      else
        printf '%s' $1 | base64 --decode
      fi
    }

#  --------------------------------------------------
#   7.  Pentesting
#  --------------------------------------------------

    # Subdomain analysis
    function subanalyzer() {
      if [[ -z "$1" ]]; then
        echo "Usage: subdomain_analysis <domain>"
        return 1
      fi

      local domain="$1"
      local results_dir="${domain}-results"

      # Create results directory
      echo "[+] Creating results directory: $results_dir"
      mkdir -p "$results_dir" || { echo "[-] Failed to create directory"; return 1; }

      # Step 1: Run subfinder
      echo "[+] Running subfinder for $domain..."
      subfinder -d "$domain" -silent -o "$results_dir/subdomains.txt" || {
          echo "[-] Subfinder failed"
          return 1
      }

      local subdomain_count=$(wc -l < "$results_dir/subdomains.txt")
      echo "[+] Found $subdomain_count subdomains"

      # Step 2: Check alive subdomains with httpx
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

      # Clean URLs for gowitness (remove status codes and titles)
      echo "[+] Cleaning URLs for screenshot capture..."
      awk '{print $1}' "$results_dir/alive_subdomains.txt" > "$results_dir/clean_urls.txt"

      # Step 3: Check for .git files
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

      # Step 4: Take screenshots with gowitness
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

      echo "[+] Analysis complete! Results saved in $results_dir/"
      echo "    - Subdomains: $results_dir/subdomains.txt"
      echo "    - Alive hosts: $results_dir/alive_subdomains.txt"
      echo "    - Git files: $results_dir/git_found.txt"
      echo "    - Screenshots: $results_dir/screenshots/"
  }

#  --------------------------------------------------
#   8.  Misc
#  --------------------------------------------------
