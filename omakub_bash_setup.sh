#!/bin/bash

#############################################
# My Favorite Bash Setup for Omakub
# Follows Omakub's structure and conventions
# Safe installation alongside Omakub defaults
#############################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Get actual user
if [ -n "$SUDO_USER" ]; then
  ACTUAL_USER=$SUDO_USER
  USER_HOME=$(eval echo ~$SUDO_USER)
else
  ACTUAL_USER=$USER
  USER_HOME=$HOME
fi

CUSTOM_DIR="$USER_HOME/.local/share/mybash"

log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[✓]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[⚠]${NC} $1"
}

log_header() {
  echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}${BOLD}$1${NC}"
  echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

show_banner() {
  clear
  echo -e "${CYAN}"
  cat <<"EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║    ⚡ My Favorite Bash Setup for Omakub ⚡           ║
║                                                       ║
║      Follows Omakub's structure & conventions!       ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
  echo -e "${NC}\n"
}

create_structure() {
  log_header "📁 Creating Directory Structure"

  mkdir -p "$CUSTOM_DIR"
  chown -R $ACTUAL_USER:$ACTUAL_USER "$CUSTOM_DIR"

  log_success "Created $CUSTOM_DIR"
}

create_aliases() {
  log_header "🔗 Creating Custom Aliases"

  cat >"$CUSTOM_DIR/aliases" <<'ALIASEOF'
# ============================================
# MY FAVORITE BASH ALIASES
# ============================================

# ============================================
# NAVIGATION SHORTCUTS
# ============================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'

# Enhanced ls (only if eza not available)
if ! command -v eza &> /dev/null; then
    alias ll='ls -alFh'
    alias la='ls -A'
    alias l='ls -CF'
    alias lt='ls -alFht'
    alias lS='ls -alFhS'
fi

# ============================================
# GIT SHORTCUTS
# ============================================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate --all'
alias gls='git log --oneline --graph --decorate'
alias glo='git log --oneline -10'
alias gst='git stash'
alias gstp='git stash pop'
alias gcl='git clone'
alias gm='git merge'
alias gr='git remote -v'
alias grao='git remote add origin'
alias grso='git remote set-url origin'

# ============================================
# DOCKER SHORTCUTS
# ============================================
alias d='docker'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias di='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"'
alias drm='docker rm'
alias drmi='docker rmi'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias dclean='docker system prune -af'
alias dstats='docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"'

# Docker Compose
alias dc='docker-compose'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'
alias dcr='docker-compose restart'
alias dcps='docker-compose ps'

# ============================================
# KUBERNETES SHORTCUTS
# ============================================
alias k='kubectl'
alias kgp='kubectl get pods -o wide'
alias kgs='kubectl get svc -o wide'
alias kgd='kubectl get deployments -o wide'
alias kgn='kubectl get nodes -o wide'
alias kga='kubectl get all -o wide'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'

# ============================================
# TERRAFORM SHORTCUTS
# ============================================
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfo='terraform output'
alias tfs='terraform state'
alias tfv='terraform validate'
alias tff='terraform fmt'
alias tfaa='terraform apply -auto-approve'
alias tfda='terraform destroy -auto-approve'

# ============================================
# AWS SHORTCUTS
# ============================================
alias awsp='export AWS_PROFILE='
alias awsr='export AWS_REGION='
alias awsl='aws configure list'

# ============================================
# SYSTEM SHORTCUTS
# ============================================
alias h='history'
alias c='clear'
alias q='exit'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %T"'
alias myip='curl -s ifconfig.me'
alias localip='hostname -I | awk '"'"'{print $1}'"'"''
alias ports='netstat -tulanp'
alias meminfo='free -m -l -t'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias disk='df -h'

# ============================================
# FILE OPERATIONS
# ============================================
alias cp='cp -iv'
alias mv='mv -iv'

# ============================================
# Safe delete - move to trash instead of permanent removal
# ============================================
alias rm='trash'
alias trash-list='list_trash'
alias trash-restore='restore_trash'
alias trash-empty='empty_trash'
alias trash-clean='clean_old_trash'
alias force-rm='force_rm'
alias mkdir='mkdir -pv'

# ============================================
# DEVELOPMENT SHORTCUTS
# ============================================
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv venv && source venv/bin/activate'
alias serve='python3 -m http.server'

# Node.js
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias ni='npm install'
alias nid='npm install --save-dev'

# ============================================
# NETWORK & API
# ============================================
alias ping='ping -c 5'
alias header='curl -I'
alias weather='curl wttr.in'

# ============================================
# PRODUCTIVITY SHORTCUTS
# ============================================
alias m1='alias g1="cd $(pwd)"'
alias m2='alias g2="cd $(pwd)"'
alias m3='alias g3="cd $(pwd)"'
alias m4='alias g4="cd $(pwd)"'
alias m5='alias g5="cd $(pwd)"'

# View cheatsheet
alias cheat='cat ~/.local/share/mybash/cheatsheet'
ALIASEOF

  chown $ACTUAL_USER:$ACTUAL_USER "$CUSTOM_DIR/aliases"
  log_success "Created custom aliases"
}

create_functions() {
  log_header "⚙️  Creating Custom Functions"

  cat >"$CUSTOM_DIR/functions" <<'FUNCEOF'
# ============================================
# MY FAVORITE BASH FUNCTIONS
# ============================================

# Git commit with message
#gcm() {
#    if [ -z "$1" ]; then
#        echo "Usage: gcm <message>"
#        return 1
#    fi
#    git commit -m "$*"
#}

# Quick commit and push
gcp() {
    git add .
    git commit -m "$*"
    git push
}

# Create and checkout new branch
gnb() {
    git checkout -b "$1"
}

# Git log pretty
glog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
}

# Enhanced docker ps with colors
dls() {
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;32mRUNNING CONTAINERS\033[0m"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

# Docker images with formatting
dimages() {
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;35mDOCKER IMAGES\033[0m"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

# Docker shell into container
dsh() {
    docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Kubernetes pods with formatting
kpods() {
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;32mKUBERNETES PODS\033[0m"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    kubectl get pods -o wide
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

# Kubernetes shell into pod
ksh() {
    kubectl exec -it $(kubectl get pods | grep "$1" | head -1 | awk '{print $1}') -- /bin/bash
}

# Kubernetes switch namespace
kswitch() {
    kubectl config set-context --current --namespace="$1"
}

# AWS switch profile
awsprofile() {
    export AWS_PROFILE="$1"
    echo "AWS Profile switched to: $1"
    aws configure list
}

# Listening ports
lports() {
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;32mLISTENING PORTS\033[0m"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    sudo lsof -iTCP -sTCP:LISTEN -n -P | column -t
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

# System info
sysinfo() {
    echo -e "\n\033[0;36mSystem Information:\033[0m\n"
    echo "Hostname: $(hostname)"
    echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')"
}

# Enhanced system summary
syssum() {
    echo -e "\n\033[0;36m╔══════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[0;36m║\033[0m      \033[1mSYSTEM SUMMARY\033[0m                                    \033[0;36m║\033[0m"
    echo -e "\033[0;36m╚══════════════════════════════════════════════════════════╝\033[0m\n"
    
    echo -e "\033[0;36m┌──────────────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[0;36m│\033[0m \033[0;32mGENERAL INFO\033[0m                                           \033[0;36m│\033[0m"
    echo -e "\033[0;36m├──────────────────────────────────────────────────────────┤\033[0m"
    printf "\033[0;36m│\033[0m %-15s \033[1;33m%-40s\033[0m \033[0;36m│\033[0m\n" "Hostname:" "$(hostname)"
    printf "\033[0;36m│\033[0m %-15s \033[1;33m%-40s\033[0m \033[0;36m│\033[0m\n" "OS:" "$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"' | cut -c1-40)"
    printf "\033[0;36m│\033[0m %-15s \033[1;33m%-40s\033[0m \033[0;36m│\033[0m\n" "Kernel:" "$(uname -r)"
    printf "\033[0;36m│\033[0m %-15s \033[1;33m%-40s\033[0m \033[0;36m│\033[0m\n" "Uptime:" "$(uptime -p)"
    echo -e "\033[0;36m└──────────────────────────────────────────────────────────┘\033[0m\n"
    
    echo -e "\033[0;36m┌──────────────────────────────────────────────────────────┐\033[0m"
    echo -e "\033[0;36m│\033[0m \033[0;35mRESOURCE USAGE\033[0m                                        \033[0;36m│\033[0m"
    echo -e "\033[0;36m├──────────────────────────────────────────────────────────┤\033[0m"
    printf "\033[0;36m│\033[0m %-15s \033[1;33m%-40s\033[0m \033[0;36m│\033[0m\n" "Memory:" "$(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    printf "\033[0;36m│\033[0m %-15s \033[1;33m%-40s\033[0m \033[0;36m│\033[0m\n" "Disk (/):" "$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')"
    echo -e "\033[0;36m└──────────────────────────────────────────────────────────┘\033[0m\n"
}

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Go up N directories
up() {
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++)); do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Find files
#ff() {
#    find . -type f -iname '*'"$*"'*' -ls
#}

# Extract archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Backup file
bak() {
    cp "$1" "${1}.$(date +%Y%m%d_%H%M%S).bak"
}

# Generate random password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 48 | cut -c1-${length}
}

# Quick web server
webserver() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Quick TODO
todo() {
    if [ -z "$1" ]; then
        if [ -f "$HOME/todo.txt" ]; then
            cat "$HOME/todo.txt"
        else
            echo "No todos found. Add one with: todo <item>"
        fi
    else
        echo "[ ] $*" >> "$HOME/todo.txt"
        echo "Todo added: $*"
    fi
}

# Quick notes
note() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $*" >> $HOME/notes.txt
}

notes() {
    if [ -f $HOME/notes.txt ]; then
        cat $HOME/notes.txt
    else
        echo "No notes found."
    fi
}

# Check port
port() {
    nc -zv localhost $1
}
# ============================================
# TRASH MANAGEMENT SYSTEM
# ============================================

# Trash directory setup
TRASH_DIR="$HOME/.local/share/Trash/files"
TRASH_INFO="$HOME/.local/share/Trash/info"

# Initialize trash directories
init_trash() {
    mkdir -p "$TRASH_DIR" "$TRASH_INFO"
}

# Move files to trash instead of removing (with safety checks)
trash() {
    init_trash
    
    # Safety check for dangerous patterns
    for arg in "$@"; do
        if [[ "$arg" == "/" ]] || [[ "$arg" == "/*" ]] || [[ "$arg" == "~" ]] || [[ "$arg" == "~/*" ]]; then
            echo -e "\033[1;31m[DANGER]\033[0m Refusing to trash: $arg"
            echo "This is too dangerous. Use force-rm with extreme caution if needed."
            return 1
        fi
        
        # Check for root directory deletions
        if [[ "$arg" == "/bin" ]] || [[ "$arg" == "/usr" ]] || [[ "$arg" == "/etc" ]] || [[ "$arg" == "/var" ]]; then
            echo -e "\033[1;31m[DANGER]\033[0m Refusing to trash system directory: $arg"
            return 1
        fi
    done
    
    # Count files if wildcard is used
    local file_count=0
    local has_wildcard=false
    
    for item in "$@"; do
        if [[ "$item" != -* ]]; then
            # Expand wildcards to count files
            if [[ "$item" == *"*"* ]] || [[ "$item" == *"?"* ]]; then
                has_wildcard=true
                # Use array to properly count expanded files
                local files=($item)
                file_count=$((file_count + ${#files[@]}))
            fi
        fi
    done
    
    # Warn if moving many files
    if [ "$has_wildcard" = true ] && [ "$file_count" -gt 50 ]; then
        echo -e "\033[1;33m[WARNING]\033[0m This will move $file_count files to trash"
        read -p "Continue? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            echo "[CANCELLED]"
            return 1
        fi
    fi
    
    # Process each item
    local moved_count=0
    for item in "$@"; do
        # Skip flags
        if [[ "$item" == -* ]]; then
            continue
        fi
        
        # Expand wildcards
        for file in $item; do
            if [ -e "$file" ]; then
                local filename=$(basename "$file")
                local timestamp=$(date +%Y%m%d_%H%M%S_%N)
                local trash_name="${filename}_${timestamp}"
                
                # Get absolute path before moving
                local abs_path=$(readlink -f "$file")
                
                mv "$file" "$TRASH_DIR/$trash_name"
                echo -e "\033[0;32m[TRASH]\033[0m Moved to trash: $file → $trash_name"
                
                # Save metadata for restore
                echo "$(date '+%Y-%m-%d %H:%M:%S')|$abs_path|$trash_name" >> "$TRASH_INFO/trash.log"
                
                moved_count=$((moved_count + 1))
            else
                echo -e "\033[0;31m[ERROR]\033[0m File not found: $file"
            fi
        done
    done
    
    if [ "$moved_count" -gt 0 ]; then
        echo -e "\033[1;36m[INFO]\033[0m $moved_count item(s) moved to trash"
        echo -e "       Use 'trash-list' to view, 'trash-restore' to recover"
    fi
}

# List trash contents
list_trash() {
    init_trash
    
    echo -e "\n\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1;33mTRASH CONTENTS\033[0m"
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    
    if [ -z "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
        echo -e "\033[0;32m[EMPTY]\033[0m Trash is empty"
    else
        ls -lh "$TRASH_DIR"
        echo ""
        local count=$(ls -1 "$TRASH_DIR" | wc -l)
        local size=$(du -sh "$TRASH_DIR" 2>/dev/null | cut -f1)
        echo -e "\033[1;36m[INFO]\033[0m Total: $count items, Size: $size"
    fi
    
    echo -e "\033[0;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m\n"
}

# Restore from trash
restore_trash() {
    init_trash
    
    if [ -z "$1" ]; then
        echo "Usage: trash-restore <filename_from_trash>"
        echo ""
        list_trash
        return 1
    fi
    
    local file="$1"
    
    if [ -f "$TRASH_DIR/$file" ]; then
        # Try to get original location from log
        local original_path=$(grep "$file" "$TRASH_INFO/trash.log" | tail -1 | cut -d'|' -f2)
        
        if [ -n "$original_path" ]; then
            local original_dir=$(dirname "$original_path")
            local original_name=$(basename "$original_path")
            
            # Ask where to restore
            echo -e "\033[1;33m[RESTORE]\033[0m Original location: $original_path"
            read -p "Restore to original location? (yes/no/current): " choice
            
            case $choice in
                yes)
                    mkdir -p "$original_dir"
                    mv "$TRASH_DIR/$file" "$original_path"
                    echo -e "\033[0;32m[RESTORED]\033[0m $file → $original_path"
                    ;;
                current)
                    mv "$TRASH_DIR/$file" "./$original_name"
                    echo -e "\033[0;32m[RESTORED]\033[0m $file → ./$original_name"
                    ;;
                *)
                    mv "$TRASH_DIR/$file" .
                    echo -e "\033[0;32m[RESTORED]\033[0m $file → $(pwd)"
                    ;;
            esac
        else
            mv "$TRASH_DIR/$file" .
            echo -e "\033[0;32m[RESTORED]\033[0m $file → $(pwd)"
        fi
        
        # Remove from log
        sed -i "/$file/d" "$TRASH_INFO/trash.log" 2>/dev/null
    else
        echo -e "\033[0;31m[ERROR]\033[0m File not found in trash: $file"
        echo ""
        list_trash
        return 1
    fi
}

# Empty entire trash
empty_trash() {
    init_trash
    
    if [ -z "$(ls -A "$TRASH_DIR" 2>/dev/null)" ]; then
        echo -e "\033[0;32m[INFO]\033[0m Trash is already empty"
        return 0
    fi
    
    local count=$(ls -1 "$TRASH_DIR" | wc -l)
    local size=$(du -sh "$TRASH_DIR" 2>/dev/null | cut -f1)
    
    echo -e "\033[1;31m[WARNING]\033[0m About to permanently delete:"
    echo "  • $count items"
    echo "  • $size of data"
    echo ""
    read -p "Type 'DELETE' to confirm permanent removal: " confirm
    
    if [ "$confirm" = "DELETE" ]; then
        rm -rf "$TRASH_DIR"/*
        rm -f "$TRASH_INFO/trash.log"
        echo -e "\033[1;32m[EMPTIED]\033[0m Trash has been permanently emptied"
    else
        echo -e "\033[0;33m[CANCELLED]\033[0m Trash not emptied"
    fi
}

# Clean old trash (files older than 30 days)
clean_old_trash() {
    init_trash
    
    local before_count=$(ls -1 "$TRASH_DIR" 2>/dev/null | wc -l)
    
    find "$TRASH_DIR" -type f -mtime +30 -delete 2>/dev/null
    
    local after_count=$(ls -1 "$TRASH_DIR" 2>/dev/null | wc -l)
    local removed=$((before_count - after_count))
    
    if [ "$removed" -gt 0 ]; then
        echo -e "\033[1;32m[CLEANED]\033[0m Removed $removed files older than 30 days from trash"
    else
        echo -e "\033[0;32m[INFO]\033[0m No old files to clean"
    fi
}

# Force delete (bypass trash) - use with EXTREME caution!
force_rm() {
    if [ -z "$1" ]; then
        echo "Usage: force-rm <file>"
        echo -e "\033[1;31m[WARNING]\033[0m This PERMANENTLY deletes files, bypassing trash!"
        return 1
    fi
    
    echo -e "\033[1;31m[DANGER]\033[0m You are about to PERMANENTLY delete:"
    for item in "$@"; do
        echo "  • $item"
    done
    echo ""
    echo -e "\033[1;33m[WARNING]\033[0m This action CANNOT be undone!"
    read -p "Type 'PERMANENT DELETE' to confirm: " confirm
    
    if [ "$confirm" = "PERMANENT DELETE" ]; then
        /bin/rm -rf "$@"
        echo -e "\033[1;31m[DELETED]\033[0m Permanently removed: $*"
    else
        echo -e "\033[0;33m[CANCELLED]\033[0m Nothing was deleted"
    fi
}
FUNCEOF

  chown $ACTUAL_USER:$ACTUAL_USER "$CUSTOM_DIR/functions"
  log_success "Created custom functions"
}

create_init() {
  log_header "🚀 Creating Initialization File"

  cat >"$CUSTOM_DIR/init" <<'INITEOF'
# ============================================
# MY BASH INITIALIZATION
# ============================================

# Enhanced history
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Append to history
shopt -s histappend 2>/dev/null
shopt -s cmdhist 2>/dev/null

# Environment
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
INITEOF

  chown $ACTUAL_USER:$ACTUAL_USER "$CUSTOM_DIR/init"
  log_success "Created initialization file"
}

create_loader() {
  log_header "📝 Creating Loader File"

  cat >"$CUSTOM_DIR/rc" <<'RCEOF'
# ============================================
# MY FAVORITE BASH SETUP LOADER
# Load all custom configurations
# ============================================

mybash_dir="$HOME/.local/share/mybash"

[ -f "$mybash_dir/aliases" ] && source "$mybash_dir/aliases"
[ -f "$mybash_dir/functions" ] && source "$mybash_dir/functions"
[ -f "$mybash_dir/init" ] && source "$mybash_dir/init"
RCEOF

  chown $ACTUAL_USER:$ACTUAL_USER "$CUSTOM_DIR/rc"
  log_success "Created loader file"
}

create_cheatsheet() {
  log_header "📋 Creating Cheatsheet"

  cat >"$CUSTOM_DIR/cheatsheet" <<'CHEATEOF'
╔══════════════════════════════════════════════════════════════╗
║         🚀 MY FAVORITE BASH SHORTCUTS CHEATSHEET 🚀          ║
╚══════════════════════════════════════════════════════════════╝

GIT SHORTCUTS:
  gs          - git status
  ga .        - git add all
  gc "msg"    - git commit with message
  gcm "msg"   - git commit (function)
  gp          - git push
  gpl         - git pull
  gl          - git log (pretty graph)
  glog        - git log (detailed pretty)
  gb          - git branch
  gco <br>    - git checkout branch
  gnb <name>  - create & checkout new branch
  gcp "msg"   - add, commit, and push

DOCKER SHORTCUTS:
  dps         - docker ps (formatted)
  dpsa        - docker ps -a (formatted)
  dls         - docker ps (beautiful table)
  dimages     - docker images (beautiful table)
  dex <id>    - docker exec -it
  dsh <id>    - docker shell (bash/sh)
  dlog <id>   - docker logs -f
  dcu         - docker-compose up -d
  dcd         - docker-compose down
  dclean      - docker system prune -af

KUBERNETES:
  kgp         - kubectl get pods
  kpods       - kubectl get pods (beautiful)
  kgs         - kubectl get services
  kl <pod>    - kubectl logs -f
  kex <pod>   - kubectl exec -it
  ksh <pod>   - shell into pod
  kswitch <ns>- switch namespace

TERRAFORM:
  tfi         - terraform init
  tfp         - terraform plan
  tfa         - terraform apply
  tfaa        - terraform apply -auto-approve
  tfd         - terraform destroy
  tff         - terraform fmt

AWS:
  awsprofile <name> - switch AWS profile
  awsl              - show current AWS config

NAVIGATION:
  ..          - cd up one level
  ...         - cd up two levels
  mkcd <dir>  - make directory and cd into it
  up <n>      - go up n directories
  m1-m5       - bookmark current directory
  g1-g5       - return to bookmarked directory

SYSTEM:
  sysinfo     - show system information
  syssum      - show detailed system summary
  myip        - show public IP
  lports      - show listening ports
  disk        - disk usage (df -h)
  duf         - disk usage (modern, colorful)
  ncdu        - disk usage analyzer (interactive)

UTILITIES:
  extract <f> - extract any archive
  bak <file>  - backup file with timestamp
  genpass     - generate random password
  webserver   - start web server (port 8000)
  todo <item> - add todo item
  todo        - show all todos
  note <text> - add quick note
  notes       - show all notes
  ff <name>   - find files by name

TRASH MANAGEMENT (SAFE DELETE):
  rm <file>           - move to trash (safe delete)
  rm -rf <file>       - SAFE! moves to trash (ignores -rf)
  trash-list          - show trash contents
  trash-restore <f>   - restore file from trash
  trash-empty         - empty trash (permanent delete)
  trash-clean         - remove files older than 30 days
  force-rm <file>     - DANGEROUS! bypass trash (permanent)

View this anytime: cheat
CHEATEOF

  chown $ACTUAL_USER:$ACTUAL_USER "$CUSTOM_DIR/cheatsheet"
  log_success "Created cheatsheet"
}

integrate_with_bashrc() {
  log_header "🔗 Integrating with .bashrc"

  # Check if already integrated
  if grep -q ".local/share/mybash/rc" "$USER_HOME/.bashrc"; then
    log_warning "Already integrated with .bashrc"
    return
  fi

  # Add to bashrc
  cat >>"$USER_HOME/.bashrc" <<'BASHRCEOF'

# ============================================
# MY FAVORITE BASH CUSTOMIZATIONS
# Load after Omakub defaults
# ============================================
[ -f ~/.local/share/mybash/rc ] && source ~/.local/share/mybash/rc
BASHRCEOF

  log_success "Integrated with .bashrc"
}

show_completion() {
  log_header "✨ Installation Complete! ✨"

  echo -e "${GREEN}${BOLD}Your favorite bash setup is now installed! 🚀${NC}\n"

  echo -e "${CYAN}Installation Details:${NC}"
  echo "  ✓ Follows Omakub's structure"
  echo "  ✓ All files in ~/.local/share/mybash/"
  echo "  ✓ Loads AFTER Omakub defaults"
  echo "  ✓ Won't interfere with Omakub"

  echo -e "\n${YELLOW}${BOLD}Next Steps:${NC}"
  echo "  1. Run: ${BOLD}source ~/.bashrc${NC}"
  echo "  2. Type: ${BOLD}cheat${NC} (to see all shortcuts)"
  echo "  3. Try: ${BOLD}syssum${NC}, ${BOLD}dls${NC}, ${BOLD}kpods${NC}"

  echo -e "\n${CYAN}Files Created:${NC}"
  echo "  • ~/.local/share/mybash/rc (loader)"
  echo "  • ~/.local/share/mybash/aliases"
  echo "  • ~/.local/share/mybash/functions"
  echo "  • ~/.local/share/mybash/init"
  echo "  • ~/.local/share/mybash/cheatsheet"

  echo -e "\n${MAGENTA}Customize:${NC}"
  echo "  • Edit files in: ${BOLD}~/.local/share/mybash/${NC}"
  echo "  • Add more aliases, functions, etc."
  echo "  • Everything loads after Omakub"

  echo -e "\n${GREEN}Happy coding! 🎉${NC}\n"
}

main() {
  show_banner

  log_info "Setting up your favorite bash for Omakub"
  log_info "User: $ACTUAL_USER"
  log_info "Directory: $CUSTOM_DIR"
  sleep 2

  create_structure
  create_aliases
  create_functions
  create_init
  create_loader
  create_cheatsheet
  integrate_with_bashrc
  show_completion
}

main
