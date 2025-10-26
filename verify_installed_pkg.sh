#!/bin/bash

#############################################
# Installation Verification Script
# Checks all DevOps tools and utilities
#############################################

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# Counters
INSTALLED=0
NOT_INSTALLED=0

# Check function
check_tool() {
    local name=$1
    local command=$2
    local version_flag=${3:-"--version"}
    
    if command -v $command &> /dev/null; then
        echo -ne "${GREEN}✓${NC} ${name}: "
        if [ "$version_flag" != "none" ]; then
            $command $version_flag 2>&1 | head -n1
        else
            echo "Installed"
        fi
        ((INSTALLED++))
        return 0
    else
        echo -e "${RED}✗${NC} ${name}: Not installed"
        ((NOT_INSTALLED++))
        return 1
    fi
}

# Header
clear
echo -e "${CYAN}${BOLD}"
cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║     🔍 Installation Verification Report 🔍           ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}\n"

# DevOps Tools Section
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}DevOps Tools${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_tool "Docker" "docker" "--version"
check_tool "Docker Compose" "docker-compose" "--version"
check_tool "AWS CLI" "aws" "--version"
check_tool "Terraform" "terraform" "version"
check_tool "Terragrunt" "terragrunt" "--version"
check_tool "Terraform-docs" "terraform-docs" "--version"
check_tool "Kubectl" "kubectl" "version --client --short"
check_tool "Helm" "helm" "version --short"
check_tool "eksctl" "eksctl" "version"
check_tool "k9s" "k9s" "version"
check_tool "Ansible" "ansible" "--version"
check_tool "Jenkins" "jenkins" "--version"
check_tool "Minikube" "minikube" "version"
check_tool "Prometheus" "prometheus" "--version"
check_tool "Grafana" "grafana-server" "-v"
check_tool "lazydocker" "lazydocker" "--version"

# Programming Languages
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Programming Languages & Runtimes${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_tool "Python3" "python3" "--version"
check_tool "pip3" "pip3" "--version"
check_tool "Node.js" "node" "--version"
check_tool "npm" "npm" "--version"
check_tool "Go" "go" "version"

# Advanced CLI Utilities
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Advanced CLI Utilities${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_tool "FZF" "fzf" "--version"
check_tool "Neovim" "nvim" "--version"
check_tool "Zoxide" "zoxide" "--version"
check_tool "Bat" "bat" "--version"
if ! command -v bat &> /dev/null; then
    check_tool "Bat (batcat)" "batcat" "--version"
fi
check_tool "Ripgrep" "rg" "--version"
check_tool "Eza" "eza" "--version"
check_tool "fd" "fd" "--version"
if ! command -v fd &> /dev/null; then
    check_tool "fd (fdfind)" "fdfind" "--version"
fi
check_tool "Delta" "delta" "--version"
check_tool "btop++" "btop" "--version"
check_tool "lazygit" "lazygit" "--version"
check_tool "tldr" "tldr" "--version"
check_tool "duf" "duf" "--version"
check_tool "ncdu" "ncdu" "--version"

# Network & API Tools
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Network & API Tools${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_tool "HTTPie" "http" "--version"
check_tool "curl" "curl" "--version"
check_tool "wget" "wget" "--version"

# Data Processing Tools
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Data Processing Tools${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_tool "yq" "yq" "--version"

# System Tools
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}System Tools${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

check_tool "Git" "git" "--version"
check_tool "Vim" "vim" "--version"
check_tool "Nano" "nano" "--version"
check_tool "Unzip" "unzip" "-v"
check_tool "Tar" "tar" "--version"
check_tool "Gzip" "gzip" "--version"
check_tool "jq" "jq" "--version"
check_tool "Tree" "tree" "--version"
check_tool "Htop" "htop" "--version"
check_tool "Net-tools" "netstat" "--version"
check_tool "tmux" "tmux" "-V"

# Check services status
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Services Status${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check Docker service
if systemctl is-active --quiet docker 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Docker service: Running"
    ((INSTALLED++))
else
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}!${NC} Docker service: Not running (but installed)"
    else
        echo -e "${RED}✗${NC} Docker service: Not installed"
    fi
    ((NOT_INSTALLED++))
fi

# Check Jenkins service
if systemctl is-active --quiet jenkins 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Jenkins service: Running"
    ((INSTALLED++))
else
    if command -v jenkins &> /dev/null || [ -f /etc/init.d/jenkins ]; then
        echo -e "${YELLOW}!${NC} Jenkins service: Not running (but installed)"
    else
        echo -e "${RED}✗${NC} Jenkins service: Not installed"
    fi
    ((NOT_INSTALLED++))
fi

# Check Prometheus service
if systemctl is-active --quiet prometheus 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Prometheus service: Running (Port 9090)"
    ((INSTALLED++))
else
    if command -v prometheus &> /dev/null; then
        echo -e "${YELLOW}!${NC} Prometheus service: Not running (but installed)"
    else
        echo -e "${RED}✗${NC} Prometheus service: Not installed"
    fi
    ((NOT_INSTALLED++))
fi

# Check Grafana service
if systemctl is-active --quiet grafana-server 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Grafana service: Running (Port 3000)"
    ((INSTALLED++))
else
    if command -v grafana-server &> /dev/null; then
        echo -e "${YELLOW}!${NC} Grafana service: Not running (but installed)"
    else
        echo -e "${RED}✗${NC} Grafana service: Not installed"
    fi
    ((NOT_INSTALLED++))
fi

# Check configuration files
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Configuration Files${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check various config files
[ -f ~/.bashrc ] && echo -e "${GREEN}✓${NC} ~/.bashrc exists" || echo -e "${RED}✗${NC} ~/.bashrc missing"
[ -f ~/.bash_aliases ] && echo -e "${GREEN}✓${NC} ~/.bash_aliases exists" || echo -e "${YELLOW}!${NC} ~/.bash_aliases not found"
[ -d ~/.config/nvim ] && echo -e "${GREEN}✓${NC} Neovim config exists" || echo -e "${YELLOW}!${NC} Neovim config not found"
[ -f ~/.fzf.bash ] && echo -e "${GREEN}✓${NC} FZF config exists" || echo -e "${YELLOW}!${NC} FZF config not found"
[ -d ~/.fzf ] && echo -e "${GREEN}✓${NC} FZF directory exists" || echo -e "${YELLOW}!${NC} FZF directory not found"

# Check Git configuration
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Git Configuration${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

GIT_USER=$(git config --global user.name 2>/dev/null)
GIT_EMAIL=$(git config --global user.email 2>/dev/null)

if [ -n "$GIT_USER" ]; then
    echo -e "${GREEN}✓${NC} Git username: $GIT_USER"
else
    echo -e "${YELLOW}!${NC} Git username: Not configured"
fi

if [ -n "$GIT_EMAIL" ]; then
    echo -e "${GREEN}✓${NC} Git email: $GIT_EMAIL"
else
    echo -e "${YELLOW}!${NC} Git email: Not configured"
fi

# Check PATH entries
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}PATH Configuration${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo "$PATH" | tr ':' '\n' | while read -r path_entry; do
    if [ -d "$path_entry" ]; then
        echo -e "${GREEN}✓${NC} $path_entry"
    else
        echo -e "${YELLOW}!${NC} $path_entry (not found)"
    fi
done

# Summary
echo -e "\n${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Summary${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

TOTAL=$((INSTALLED + NOT_INSTALLED))
PERCENTAGE=$((INSTALLED * 100 / TOTAL))

echo -e "${GREEN}Installed:${NC} $INSTALLED"
echo -e "${RED}Not Installed:${NC} $NOT_INSTALLED"
echo -e "${CYAN}Total Checked:${NC} $TOTAL"
echo -e "${WHITE}Installation Rate:${NC} ${BOLD}$PERCENTAGE%${NC}"

if [ $NOT_INSTALLED -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}🎉 Perfect! All tools are installed! 🎉${NC}\n"
elif [ $PERCENTAGE -ge 80 ]; then
    echo -e "\n${YELLOW}${BOLD}⚡ Almost there! Most tools are installed. ⚡${NC}\n"
else
    echo -e "\n${RED}${BOLD}⚠️  Many tools are missing. Consider running the setup scripts. ⚠️${NC}\n"
fi

# Quick test commands
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}${BOLD}Quick Test Commands${NC}"
echo -e "${MAGENTA}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BLUE}Try these commands to test your DevOps tools:${NC}\n"
echo -e "${CYAN}Core Tools:${NC}"
echo "  docker ps                  # Test Docker"
echo "  docker-compose --version   # Test Docker Compose"
echo "  aws --version              # Test AWS CLI"
echo "  terraform version          # Test Terraform"
echo "  terragrunt --version       # Test Terragrunt"
echo "  terraform-docs --version   # Test Terraform-docs"
echo ""
echo -e "${CYAN}Kubernetes Tools:${NC}"
echo "  kubectl version --client   # Test Kubectl"
echo "  helm version --short       # Test Helm"
echo "  eksctl version             # Test eksctl"
echo "  k9s version                # Test k9s"
echo "  minikube version           # Test Minikube"
echo ""
echo -e "${CYAN}Programming Languages:${NC}"
echo "  python3 --version          # Test Python"
echo "  pip3 --version             # Test pip"
echo "  node --version             # Test Node.js"
echo "  npm --version              # Test npm"
echo "  go version                 # Test Go"
echo ""
echo -e "${CYAN}Monitoring & CI/CD:${NC}"
echo "  prometheus --version       # Test Prometheus"
echo "  grafana-server -v          # Test Grafana"
echo "  ansible --version          # Test Ansible"
echo ""
echo -e "${CYAN}Services:${NC}"
echo "  systemctl status docker    # Check Docker service"
echo "  systemctl status jenkins   # Check Jenkins service"
echo "  systemctl status prometheus # Check Prometheus service"
echo "  systemctl status grafana-server # Check Grafana service"
echo ""
echo -e "${CYAN}Web Access:${NC}"
echo "  http://localhost:8080      # Jenkins (if running)"
echo "  http://localhost:9090      # Prometheus (if running)"
echo "  http://localhost:3000      # Grafana (if running)"
echo ""
echo -e "${CYAN}CLI Utilities:${NC}"
echo "  fzf --version              # Test FZF"
echo "  nvim --version             # Test Neovim"
echo "  bat --version              # Test Bat"
echo "  rg --version               # Test Ripgrep"
echo "  eza --version              # Test Eza"
echo "  btop --version             # Test btop"
echo "  z ~                        # Test Zoxide"
echo "  tldr ls                    # Test tldr"

echo -e "\n${CYAN}${BOLD}For detailed testing, run individual commands above.${NC}\n"
