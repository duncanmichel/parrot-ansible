# Common aliases
alias ll='ls -lha'
alias l='ls -CF'
alias em='emacs -nw'
alias dd='dd status=progress'
alias _='sudo'
alias _i='sudo -i'

# Convienence 
alias http='python3 -m http.server 8000'
alias simplehttp='ifconfig tun0 | grep "inet "; python3 -m http.server'
alias log='script "/home/ph03nix0x90/tmux/tmux_history_$(date +%Y%m%d)_$(date +%s).log"'

# nmap automator
donmap() {
    if [ -z $IP ]; then
        echo '[-] Error: Environment variable $IP not set.'
        return 1
    fi
    echo -e "\n[+] Starting simple scan..."
    nmap --privileged -sS $IP --open -v -oN simplescan.txt
    echo -e "\n[+] Starting full TCP port scan..."
    nmap --privileged -sS -p- --max-rate 5000 $IP --open -oN fullscan.txt
    echo -e "\n[+] Starting service version scan..."
    ports=$(cat fullscan.txt | awk -F / '/^[0-9]/ {print $1}' | sed -z 's/\n/,/g;s/,$/\n/')
    nmap --privileged -sC -sV -p $ports $IP -oA versionscan
    echo -e "\n[+] Starting service vulnerability scan..."
    nmap --privileged --script=vuln -p $ports $IP -oA vulnscan.txt
    echo -e "\n[+] Starting UDP scan..."
    nmap --privileged -sU --top-ports 135 $IP -oN udpscan.txt
}



# Reverse Shell Listener function
linrevshell() {
    if [ -z $1 ]; then
        echo "[-] Usage: linrevshell <port number>"
        return 1
    fi
    if [[ "$1" =~ ^-?[0-9]+$ ]]; then
        ncat -lnvp $1
    else
        echo "[-] argument is not a number."
    fi
    
}

winrevshell() {
    if [ -z $1 ]; then
        echo "[-] Usage: winrevshell <port number>"
        return 1
    fi
    if [[ "$1" =~ ^-?[0-9]+$ ]]; then
        rlwrap ncat -lnvp $1
    else
        echo "[-] argument is not a number."
    fi
    
}

# Crack Map Exec Backwards Compatibility
crackmapexec_alias_func() {
    cme "$@"
}

alias crackmapexec='crackmapexec_alias_func'

# Help people find 7z2john
7z2john_alias_func() {
    7z2john.pl "$@"
}

alias 7z2john='7z2john_alias_func'

# Help people find enum4linux-ng
enum4linux_ng_alias_func() {
    enum4linux-ng "$@"
}

alias enum4linux='enum4linux_ng_alias_func'

# Help people find things
find_string_alias_func() {
    if [ -z "$1" ]; then
        echo "Searches for a string in all files in a directory"
        echo "Usage: find_string <directory> <string>"
        return
    fi
    find $1 -name '*' -exec grep -i "$2" {} \; -print 2>/dev/null
}

alias find_string='find_string_alias_func'
