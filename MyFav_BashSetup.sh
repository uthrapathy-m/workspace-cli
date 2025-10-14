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
alias cpu='top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '"'"'{print 100 - $1"%"}'"'"''

# Enhanced ports display
lports() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}LISTENING PORTS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    sudo lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;32m" $0 "\033[0m"}' | column -t
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Enhanced disk usage
diskusage() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}${BOLD}DISK USAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    df -h | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;33m" $0 "\033[0m"}' | column -t
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Enhanced memory info
memoryinfo() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}MEMORY USAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    free -h | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;35m" $0 "\033[0m"}'
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Process table
pstable() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${BOLD}TOP PROCESSES BY CPU${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    ps aux --sort=-%cpu | head -11 | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;34m" $0 "\033[0m"}' | column -t
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Memory usage by process
memtable() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}TOP PROCESSES BY MEMORY${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    ps aux --sort=-%mem | head -11 | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;35m" $0 "\033[0m"}' | column -t
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Network connections table
netstat-table() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}${BOLD}NETWORK CONNECTIONS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    netstat -tulanp 2>/dev/null | grep LISTEN | awk '{print $1,$4,$7}' | column -t | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;33m" $0 "\033[0m"}'
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Quick system info
alias sysinfo='echo -e "\n${CYAN}System Information:${NC}\n"; echo "Hostname: $(hostname)"; echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'\'")"; echo "Kernel: $(uname -r)"; echo "Uptime: $(uptime -p)"; echo "Memory: $(free -h | awk '"'"'/^Mem:/ {print $3 "/" $2}'"'"')"; echo "Disk: $(df -h / | awk '"'"'NR==2 {print $3 "/" $2 " (" $5 " used)"}'"'"')"'#!/bin/bash

#############################################
# Workspace Productivity Boost Script
# Author: Your Name
# Description: Beautiful, productive bash enhancements
# Installs: Aliases, Functions, Prompt, Tools
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

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_header() {
    echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Show banner
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║        ⚡ Workspace Productivity Booster ⚡           ║
║                                                       ║
║     Transform your terminal into a powerhouse!       ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}\n"
}

# Create beautiful bash prompt
setup_prompt() {
    log_header "🎨 Setting Up Beautiful Bash Prompt"
    
    cat >> $USER_HOME/.bashrc << 'EOF'

# ============================================
# BEAUTIFUL BASH PROMPT WITH GIT SUPPORT
# ============================================

# Git branch in prompt
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Git status colors
git_color() {
    local git_status="$(git status 2> /dev/null)"
    if [[ $git_status =~ "nothing to commit" ]]; then
        echo -e '\033[0;32m'  # Green
    elif [[ $git_status =~ "Changes to be committed" ]]; then
        echo -e '\033[0;33m'  # Yellow
    else
        echo -e '\033[0;31m'  # Red
    fi
}

# Enhanced PS1 with colors and git
export PS1='\[\033[01;36m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[$(git_color)\]$(parse_git_branch)\[\033[00m\]\$ '

EOF
    
    log_success "Beautiful prompt configured"
}

# Create productivity aliases
setup_aliases() {
    log_header "🔗 Creating Productivity Aliases"
    
    cat > $USER_HOME/.bash_aliases << 'EOF'
# ============================================
# NAVIGATION SHORTCUTS
# ============================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Enhanced ls
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -alFht'  # Sort by time
alias lS='ls -alFhS'  # Sort by size

# ============================================
# GIT SHORTCUTS (Super Productive!)
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

# Git commit with ticket number
gcm() {
    if [ -z "$1" ]; then
        echo "Usage: gcm <message>"
        return 1
    fi
    git commit -m "$*"
}

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
alias dcps='docker-compose ps --format table'

# Enhanced docker ps with colors
dls() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}RUNNING CONTAINERS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}" | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;32m" $0 "\033[0m"}'
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Docker images with size sorting
dimages() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}DOCKER IMAGES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedSince}}" | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;35m" $0 "\033[0m"}'
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Docker system info
dsys() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}${BOLD}DOCKER SYSTEM INFO${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    docker system df --format "table {{.Type}}\t{{.TotalCount}}\t{{.Active}}\t{{.Size}}\t{{.Reclaimable}}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Docker networks table
dnet() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${BOLD}DOCKER NETWORKS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    docker network ls --format "table {{.ID}}\t{{.Name}}\t{{.Driver}}\t{{.Scope}}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Docker volumes table
dvol() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}DOCKER VOLUMES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    docker volume ls --format "table {{.Driver}}\t{{.Name}}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

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

# Kubernetes context
alias kctx='kubectl config current-context'
alias kns='kubectl config set-context --current --namespace'

# Beautiful kubectl get pods
kpods() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}KUBERNETES PODS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl get pods -o custom-columns=NAME:.metadata.name,READY:.status.containerStatuses[*].ready,STATUS:.status.phase,RESTARTS:.status.containerStatuses[*].restartCount,AGE:.metadata.creationTimestamp | awk 'NR==1{print "\033[1;36m" $0 "\033[0m"} NR>1{print "\033[0;32m" $0 "\033[0m"}'
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Kubernetes services table
ksvc() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${BOLD}KUBERNETES SERVICES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl get svc -o custom-columns=NAME:.metadata.name,TYPE:.spec.type,CLUSTER-IP:.spec.clusterIP,EXTERNAL-IP:.status.loadBalancer.ingress[*].ip,PORT:.spec.ports[*].port
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Kubernetes deployments
kdep() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}KUBERNETES DEPLOYMENTS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl get deployments -o custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,UP-TO-DATE:.status.updatedReplicas,AVAILABLE:.status.availableReplicas,AGE:.metadata.creationTimestamp
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Kubernetes nodes status
knodes() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}${BOLD}KUBERNETES NODES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl get nodes -o custom-columns=NAME:.metadata.name,STATUS:.status.conditions[-1].type,ROLES:.metadata.labels.node-role\.kubernetes\.io/*,VERSION:.status.nodeInfo.kubeletVersion,AGE:.metadata.creationTimestamp
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Kubernetes namespaces
knamespaces() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}KUBERNETES NAMESPACES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl get namespaces -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,AGE:.metadata.creationTimestamp
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Kubernetes events
kevents() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}${BOLD}KUBERNETES RECENT EVENTS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl get events --sort-by='.lastTimestamp' -o custom-columns=TIME:.lastTimestamp,TYPE:.type,REASON:.reason,OBJECT:.involvedObject.name,MESSAGE:.message | tail -20
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Kubernetes resource usage
ktop() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}${BOLD}KUBERNETES RESOURCE USAGE${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    kubectl top nodes 2>/dev/null || echo "Metrics server not available"
    echo ""
    kubectl top pods 2>/dev/null || echo "Metrics server not available"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

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

# Terraform with auto-approve
alias tfaa='terraform apply -auto-approve'
alias tfda='terraform destroy -auto-approve'

# ============================================
# AWS SHORTCUTS
# ============================================
alias awsp='export AWS_PROFILE='
alias awsr='export AWS_REGION='
alias awsl='aws configure list'

# EC2 instances table
ec2-list() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}AWS EC2 INSTANCES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType,PrivateIpAddress,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' --output table
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# S3 buckets table
s3-buckets() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${BOLD}AWS S3 BUCKETS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    aws s3 ls
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# RDS instances
rds-list() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${MAGENTA}${BOLD}AWS RDS INSTANCES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    aws rds describe-db-instances --query 'DBInstances[].[DBInstanceIdentifier,DBInstanceStatus,Engine,DBInstanceClass,Endpoint.Address]' --output table
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# EKS clusters
eks-list() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}${BOLD}AWS EKS CLUSTERS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    aws eks list-clusters --output table
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Lambda functions
lambda-list() {
    echo -e "${CYAN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}${BOLD}AWS LAMBDA FUNCTIONS${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    aws lambda list-functions --query 'Functions[].[FunctionName,Runtime,LastModified]' --output table
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# S3
alias s3-ls='aws s3 ls'
alias s3-du='aws s3 ls --summarize --human-readable --recursive'

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
alias cpu='top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '"'"'{print 100 - $1"%"}'"'"''

# Quick system info
alias sysinfo='echo -e "\n${CYAN}System Information:${NC}\n"; echo "Hostname: $(hostname)"; echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'\'")"; echo "Kernel: $(uname -r)"; echo "Uptime: $(uptime -p)"; echo "Memory: $(free -h | awk '"'"'/^Mem:/ {print $3 "/" $2}'"'"')"; echo "Disk: $(df -h / | awk '"'"'NR==2 {print $3 "/" $2 " (" $5 " used)"}'"'"')"'

# Update system
if command -v apt &> /dev/null; then
    alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
elif command -v yum &> /dev/null; then
    alias update='sudo yum update -y && sudo yum autoremove -y'
fi

# ============================================
# FILE OPERATIONS
# ============================================
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'

# Extract archives
alias extract='function _extract(){ if [ -f $1 ]; then case $1 in *.tar.bz2) tar xjf $1 ;; *.tar.gz) tar xzf $1 ;; *.bz2) bunzip2 $1 ;; *.rar) unrar e $1 ;; *.gz) gunzip $1 ;; *.tar) tar xf $1 ;; *.tbz2) tar xjf $1 ;; *.tgz) tar xzf $1 ;; *.zip) unzip $1 ;; *.Z) uncompress $1 ;; *.7z) 7z x $1 ;; *) echo "'"'"'$1'"'"' cannot be extracted" ;; esac; else echo "'"'"'$1'"'"' is not a valid file"; fi }; _extract'

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
# NETWORK & API TESTING
# ============================================
alias ping='ping -c 5'
alias fastping='ping -c 100 -i.2'
alias header='curl -I'
alias weather='curl wttr.in'

# Test if a port is open
port() {
    nc -zv localhost $1
}

# ============================================
# SEARCH & FIND
# ============================================
# Find files
alias ff='find . -type f -name'
alias fd='find . -type d -name'

# Search in files
alias sgrep='grep -r -n -H -C 5 --exclude-dir={.git,.svn,node_modules}'

# ============================================
# PROCESS MANAGEMENT
# ============================================
alias psa='ps aux'
alias psef='ps -ef'

# Kill process by name
killp() {
    ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
}

# ============================================
# PRODUCTIVITY BOOSTERS
# ============================================
# Quick directory bookmark
alias m1='alias g1="cd $(pwd)"'
alias m2='alias g2="cd $(pwd)"'
alias m3='alias g3="cd $(pwd)"'
alias m4='alias g4="cd $(pwd)"'
alias m5='alias g5="cd $(pwd)"'

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Backup a file
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Create a quick note
note() {
    echo "$(date +"%Y-%m-%d %H:%M:%S"): $*" >> $HOME/notes.txt
}

# View notes
notes() {
    if [ -f $HOME/notes.txt ]; then
        cat $HOME/notes.txt
    else
        echo "No notes found."
    fi
}

# Quick calculator
calc() {
    echo "$*" | bc -l
}

# Weather
wttr() {
    curl -s "wttr.in/${1:-}"
}

# ============================================
# FUN STUFF
# ============================================
alias please='sudo'
alias fucking='sudo'
alias matrix='cmatrix'
alias starwars='telnet towel.blinkenlights.nl'

EOF

    chown $ACTUAL_USER:$ACTUAL_USER $USER_HOME/.bash_aliases
    
    # Source aliases in bashrc if not already there
    if ! grep -q ".bash_aliases" $USER_HOME/.bashrc; then
        echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >> $USER_HOME/.bashrc
    fi
    
    log_success "Productivity aliases created"
}

# Create useful bash functions
setup_functions() {
    log_header "⚙️  Creating Useful Functions"
    
    cat >> $USER_HOME/.bash_functions << 'EOF'
# ============================================
# ADVANCED BASH FUNCTIONS
# ============================================

# Enhanced cd that also lists directory contents
cd() {
    builtin cd "$@" && ls -F
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

# Find a file with pattern in name
ff() {
    find . -type f -iname '*'"$*"'*' -ls
}

# Find text in files
ft() {
    find . -type f -exec grep -l "$1" {} \;
}

# Show directory size
dsize() {
    du -sh "$1" 2>/dev/null || du -sh .
}

# Count files in directory
count() {
    find ${1:-.} -type f | wc -l
}

# Extract any archive
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
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a backup of a file with timestamp
bak() {
    cp "$1" "${1}.$(date +%Y%m%d_%H%M%S).bak"
}

# Git log pretty
glog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
}

# Show git contributors
gcontrib() {
    git log --format='%aN' | sort -u
}

# Docker clean all
dcleanall() {
    echo "Stopping all containers..."
    docker stop $(docker ps -aq) 2>/dev/null
    echo "Removing all containers..."
    docker rm $(docker ps -aq) 2>/dev/null
    echo "Removing all images..."
    docker rmi $(docker images -q) 2>/dev/null
    echo "Removing all volumes..."
    docker volume rm $(docker volume ls -q) 2>/dev/null
    echo "Removing all networks..."
    docker network prune -f
    echo "Docker cleaned!"
}

# Docker shell into container
dsh() {
    docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh
}

# Kubernetes switch namespace
kswitch() {
    kubectl config set-context --current --namespace="$1"
}

# Kubernetes get pod logs
klog() {
    kubectl logs -f $(kubectl get pods | grep "$1" | head -1 | awk '{print $1}')
}

# Kubernetes exec into pod
ksh() {
    kubectl exec -it $(kubectl get pods | grep "$1" | head -1 | awk '{print $1}') -- /bin/bash
}

# AWS switch profile
awsprofile() {
    export AWS_PROFILE="$1"
    echo "AWS Profile switched to: $1"
    aws configure list
}

# Create a simple web server
webserver() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Generate random password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 48 | cut -c1-${length}
}

# Show public IP
publicip() {
    curl -s ifconfig.me
    echo ""
}

# Show listening ports
listening() {
    sudo lsof -iTCP -sTCP:LISTEN -n -P
}

# Quick grep with color
qgrep() {
    grep -r --color=always "$1" .
}

# Create a quick TODO
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

# Mark todo as done
todone() {
    sed -i "${1}s/\[ \]/[✓]/" "$HOME/todo.txt"
}

# Show system summary
syssum() {
    echo -e "\n${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}      ${BOLD}SYSTEM SUMMARY${NC}                                    ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}\n"
    
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${GREEN}GENERAL INFO${NC}                                           ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Hostname:" "$(hostname)"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "OS:" "$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"' | cut -c1-40)"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Kernel:" "$(uname -r)"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Uptime:" "$(uptime -p)"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}\n"
    
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${MAGENTA}NETWORK INFO${NC}                                          ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Public IP:" "$(curl -s --max-time 3 ifconfig.me || echo 'N/A')"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Local IP:" "$(hostname -I | awk '{print $1}')"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}\n"
    
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${BLUE}RESOURCE USAGE${NC}                                        ${CYAN}│${NC}"
    echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "CPU Usage:" "$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Memory:" "$(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Disk (/):" "$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}\n"
    
    # Show running services if available
    if command -v docker &> /dev/null; then
        local docker_count=$(docker ps -q 2>/dev/null | wc -l)
        echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
        echo -e "${CYAN}│${NC} ${GREEN}SERVICES${NC}                                              ${CYAN}│${NC}"
        echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
        printf "${CYAN}│${NC} %-15s ${YELLOW}%-40s${NC} ${CYAN}│${NC}\n" "Docker:" "$docker_count containers running"
        echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}\n"
    fi
}

# Quick git commit with date
qcommit() {
    git add .
    git commit -m "Update: $(date +'%Y-%m-%d %H:%M:%S')"
}

EOF

    chown $ACTUAL_USER:$ACTUAL_USER $USER_HOME/.bash_functions
    
    # Source functions in bashrc
    if ! grep -q ".bash_functions" $USER_HOME/.bashrc; then
        echo '[ -f ~/.bash_functions ] && source ~/.bash_functions' >> $USER_HOME/.bashrc
    fi
    
    log_success "Useful functions created"
}

# Setup bash history improvements
setup_history() {
    log_header "📚 Improving Bash History"
    
    cat >> $USER_HOME/.bashrc << 'EOF'

# ============================================
# ENHANCED BASH HISTORY
# ============================================
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
shopt -s histappend
shopt -s cmdhist

# Append to history after each command
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

EOF
    
    log_success "Bash history improved"
}

# Setup environment variables
setup_environment() {
    log_header "🌍 Setting Up Environment Variables"
    
    cat >> $USER_HOME/.bashrc << 'EOF'

# ============================================
# ENVIRONMENT VARIABLES
# ============================================
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

EOF
    
    log_success "Environment variables configured"
}

# Create a welcome message
setup_welcome() {
    log_header "👋 Creating Welcome Message"
    
    cat >> $USER_HOME/.bashrc << 'EOF'

# ============================================
# WELCOME MESSAGE
# ============================================
if [ -t 1 ]; then
    echo -e "\n${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}    Welcome back, ${GREEN}$(whoami)${NC}!                        ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}$(date)${NC}"
    echo -e "${GREEN}Uptime:${NC} $(uptime -p)"
    echo ""
    
    # Show git status if in git repo
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${BLUE}📂 Git Repository:${NC} $(basename $(git rev-parse --show-toplevel))"
        echo -e "${BLUE}🌿 Branch:${NC} $(git branch --show-current)"
    fi
    echo ""
fi

EOF
    
    log_success "Welcome message created"
}

# Create cheatsheet
create_cheatsheet() {
    log_header "📋 Creating Command Cheatsheet"
    
    cat > $USER_HOME/.cheatsheet << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              🚀 WORKSPACE PRODUCTIVITY CHEATSHEET 🚀          ║
╚══════════════════════════════════════════════════════════════╝

GIT SHORTCUTS:
  gs          - git status
  ga .        - git add all
  gc "msg"    - git commit with message
  gp          - git push
  gpl         - git pull
  gl          - git log (pretty)
  gb          - git branch
  gco <br>    - git checkout branch
  gnb <name>  - create & checkout new branch
  gcp "msg"   - add, commit, and push

DOCKER SHORTCUTS:
  dps         - docker ps
  dpsa        - docker ps -a
  dex <id>    - docker exec -it <id> /bin/bash
  dlog <id>   - docker logs -f
  dcu         - docker-compose up -d
  dcd         - docker-compose down
  dclean      - clean docker system

KUBERNETES:
  kgp         - kubectl get pods
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

NAVIGATION:
  ..          - cd up one level
  ...         - cd up two levels
  mkcd <dir>  - make directory and cd into it
  up <n>      - go up n directories
  m1-m5       - bookmark current directory (use g1-g5 to return)

SYSTEM:
  sysinfo     - show system information
  myip        - show public IP
  ports       - show listening ports
  disk        - disk usage
  update      - update system packages

UTILITIES:
  extract <f> - extract any archive
  backup <f>  - backup file with timestamp
  genpass     - generate random password
  webserver   - start simple web server
  weather     - show weather
  todo <item> - add todo item
  todo        - show todos

View this cheatsheet anytime: cat ~/.cheatsheet
EOF

    chown $ACTUAL_USER:$ACTUAL_USER $USER_HOME/.cheatsheet
    
    # Add alias to view cheatsheet
    echo "alias cheat='cat ~/.cheatsheet'" >> $USER_HOME/.bash_aliases
    
    log_success "Cheatsheet created (use 'cheat' command to view)"
}

# Main installation
main() {
    show_banner
    
    log_info "Installing productivity enhancements for user: $ACTUAL_USER"
    sleep 2
    
    setup_prompt
    setup_aliases
    setup_functions
    setup_history
    setup_environment
    setup_welcome
    create_cheatsheet
    
    log_header "✨ Installation Complete! ✨"
    
    echo -e "${GREEN}${BOLD}Your workspace is now supercharged! 🚀${NC}\n"
    echo -e "${CYAN}What's been added:${NC}"
    echo "  ✓ Beautiful bash prompt with git support"
    echo "  ✓ 100+ productivity aliases"
    echo "  ✓ Useful bash functions"
    echo "  ✓ Enhanced history settings"
    echo "  ✓ Welcome message on login"
    echo "  ✓ Command cheatsheet"
    
    echo -e "\n${YELLOW}${BOLD}Next Steps:${NC}"
    echo "  1. Run: source ~/.bashrc"
    echo "  2. Type: cheat (to see all shortcuts)"
    echo "  3. Try: syssum (for system summary)"
    echo "  4. Use: gs, dps, kgp (for quick commands)"
    
    echo -e "\n${CYAN}Pro Tips:${NC}"
    echo "  • Use 'm1' to bookmark a directory, 'g1' to return"
    echo "  • Type 'gcp \"message\"' for quick commit & push"
    echo "  • Use 'ksh podname' to shell into kubernetes pod"
    echo "  • Type 'todo \"task\"' to add tasks, 'todo' to view"
    
    echo -e "\n${GREEN}Happy coding! 🎉${NC}\n"
}

# Run main
main