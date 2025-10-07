#!/bin/bash

#############################################
# Advanced Linux Utilities Setup Script
# Author: Your Name
# Description: Interactive setup for advanced CLI tools and utilities
# Supports: Ubuntu, Debian, CentOS, RHEL, Amazon Linux, Fedora
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
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_header() {
    echo -e "\n${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}${BOLD}$1${NC}"
    echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Detect OS and package manager
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        log_error "Cannot detect OS. /etc/os-release not found."
        exit 1
    fi

    case $OS in
        ubuntu|debian)
            PKG_MANAGER="apt"
            UPDATE_CMD="apt update"
            INSTALL_CMD="apt install -y"
            ;;
        centos|rhel|fedora)
            PKG_MANAGER="yum"
            UPDATE_CMD="yum update -y"
            INSTALL_CMD="yum install -y"
            ;;
        amzn)
            PKG_MANAGER="yum"
            UPDATE_CMD="yum update -y"
            INSTALL_CMD="yum install -y"
            ;;
        *)
            log_error "Unsupported OS: $OS"
            exit 1
            ;;
    esac

    log_success "Detected OS: $OS $VERSION"
    log_success "Package Manager: $PKG_MANAGER"
}

# Check if running as root or with sudo
check_privileges() {
    if [ "$EUID" -ne 0 ]; then
        log_warning "This script requires sudo privileges."
        exec sudo bash "$0" "$@"
    fi
}

# Get actual user (not root when using sudo)
get_actual_user() {
    if [ -n "$SUDO_USER" ]; then
        ACTUAL_USER=$SUDO_USER
        USER_HOME=$(eval echo ~$SUDO_USER)
    else
        ACTUAL_USER=$USER
        USER_HOME=$HOME
    fi
}

# Update system
update_system() {
    log_header "📦 Updating System Packages"
    $UPDATE_CMD || log_warning "System update encountered issues"
    log_success "System packages updated"
}

# Install basic dependencies
install_dependencies() {
    log_header "🔧 Installing Build Dependencies"
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD build-essential curl wget git cmake pkg-config libssl-dev \
                      unzip gettext ninja-build automake autoconf libtool \
                      software-properties-common
    else
        $INSTALL_CMD gcc gcc-c++ make curl wget git cmake openssl-devel \
                      unzip gettext ninja-build automake autoconf libtool
    fi
    
    log_success "Build dependencies installed"
}

# Install FZF (Fuzzy Finder)
install_fzf() {
    log_header "🔍 Installing FZF (Fuzzy Finder)"
    
    if command -v fzf &> /dev/null; then
        log_warning "FZF already installed"
        fzf --version
        return
    fi
    
    # Clone FZF
    git clone --depth 1 https://github.com/junegunn/fzf.git $USER_HOME/.fzf
    chown -R $ACTUAL_USER:$ACTUAL_USER $USER_HOME/.fzf
    
    # Install FZF
    sudo -u $ACTUAL_USER bash -c "$USER_HOME/.fzf/install --all --no-update-rc"
    
    # Add to bashrc if not present
    if ! grep -q "/.fzf.bash" $USER_HOME/.bashrc 2>/dev/null; then
        echo '[ -f ~/.fzf.bash ] && source ~/.fzf.bash' >> $USER_HOME/.bashrc
    fi
    
    log_success "FZF installed"
    log_info "FZF keybindings: Ctrl+R (history), Ctrl+T (files), Alt+C (cd)"
}

# Install Neovim (latest stable)
install_neovim() {
    log_header "📝 Installing Neovim (Latest Stable)"
    
    if command -v nvim &> /dev/null; then
        log_warning "Neovim already installed"
        nvim --version | head -n1
        return
    fi
    
    # Download and install Neovim
    cd /tmp
    log_info "Fetching latest Neovim version..."
    
    # Get the latest version tag
    NVIM_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -oP '"tag_name": "\K[^"]+')
    
    if [ -z "$NVIM_VERSION" ]; then
        log_warning "Could not fetch latest version, using stable version v0.10.2"
        NVIM_VERSION="v0.10.2"
    fi
    
    log_info "Installing Neovim $NVIM_VERSION..."
    
    # Download with proper redirect following and output file
    curl -fsSL "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz" -o nvim-linux64.tar.gz
    
    # Verify download - check if file is larger than 1MB (should be ~40MB)
    if [ ! -f nvim-linux64.tar.gz ]; then
        log_error "Failed to download Neovim - file not found"
        return 1
    fi
    
    FILE_SIZE=$(stat -c%s nvim-linux64.tar.gz 2>/dev/null || stat -f%z nvim-linux64.tar.gz 2>/dev/null)
    if [ "$FILE_SIZE" -lt 1000000 ]; then
        log_error "Downloaded file is too small ($FILE_SIZE bytes), likely an error page"
        log_info "Trying alternative download method..."
        rm nvim-linux64.tar.gz
        wget -q --show-progress "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux64.tar.gz" || {
            log_error "Alternative download also failed. Installing from PPA instead..."
            sudo add-apt-repository ppa:neovim-ppa/stable -y
            apt update
            $INSTALL_CMD neovim
            log_success "Neovim installed via PPA"
            nvim --version | head -n1
            return 0
        }
    fi
    
    log_info "Download successful ($(echo "scale=1; $FILE_SIZE/1048576" | bc 2>/dev/null || echo "unknown") MB), extracting..."
    tar -xzf nvim-linux64.tar.gz
    
    # Remove old installation if exists
    rm -rf /opt/nvim
    
    mv nvim-linux64 /opt/nvim
    ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
    ln -sf /usr/local/bin/nvim /usr/local/bin/vim
    rm nvim-linux64.tar.gz
    
    # Create basic config directory
    mkdir -p $USER_HOME/.config/nvim
    chown -R $ACTUAL_USER:$ACTUAL_USER $USER_HOME/.config
    
    # Basic init.vim
    cat > $USER_HOME/.config/nvim/init.vim << 'EOF'
" Basic Neovim Configuration
set number
set relativenumber
set mouse=a
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set clipboard=unnamedplus
set ignorecase
set smartcase
set incsearch
set hlsearch
set termguicolors
syntax on
EOF
    
    chown $ACTUAL_USER:$ACTUAL_USER $USER_HOME/.config/nvim/init.vim
    
    log_success "Neovim installed"
    nvim --version | head -n1
}

# Install Zoxide (better cd)
install_zoxide() {
    log_header "🚀 Installing Zoxide (Smart cd)"
    
    if command -v zoxide &> /dev/null; then
        log_warning "Zoxide already installed"
        zoxide --version
        return
    fi
    
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    
    # Add to bashrc
    if ! grep -q "zoxide init" $USER_HOME/.bashrc 2>/dev/null; then
        echo 'eval "$(zoxide init bash)"' >> $USER_HOME/.bashrc
    fi
    
    log_success "Zoxide installed"
    log_info "Use 'z' command to jump to directories (e.g., 'z documents')"
}

# Install Bat (better cat)
install_bat() {
    log_header "🦇 Installing Bat (Better cat with syntax highlighting)"
    
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        log_warning "Bat already installed"
        return
    fi
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD bat
        # Create alias for Ubuntu (installs as batcat)
        if ! command -v bat &> /dev/null && command -v batcat &> /dev/null; then
            ln -sf /usr/bin/batcat /usr/local/bin/bat
        fi
    else
        cd /tmp
        local bat_version="0.24.0"
        wget https://github.com/sharkdp/bat/releases/download/v${bat_version}/bat-v${bat_version}-x86_64-unknown-linux-musl.tar.gz
        tar -xzf bat-v${bat_version}-x86_64-unknown-linux-musl.tar.gz
        mv bat-v${bat_version}-x86_64-unknown-linux-musl/bat /usr/local/bin/
        rm -rf bat-v${bat_version}-x86_64-unknown-linux-musl*
    fi
    
    log_success "Bat installed"
    log_info "Use 'bat' instead of 'cat' for syntax highlighting"
}

# Install Ripgrep (better grep)
install_ripgrep() {
    log_header "🔎 Installing Ripgrep (Better grep)"
    
    if command -v rg &> /dev/null; then
        log_warning "Ripgrep already installed"
        rg --version
        return
    fi
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD ripgrep
    else
        cd /tmp
        local rg_version="14.1.0"
        wget https://github.com/BurntSushi/ripgrep/releases/download/${rg_version}/ripgrep-${rg_version}-x86_64-unknown-linux-musl.tar.gz
        tar -xzf ripgrep-${rg_version}-x86_64-unknown-linux-musl.tar.gz
        mv ripgrep-${rg_version}-x86_64-unknown-linux-musl/rg /usr/local/bin/
        rm -rf ripgrep-${rg_version}-x86_64-unknown-linux-musl*
    fi
    
    log_success "Ripgrep installed"
    log_info "Use 'rg' for fast recursive searching"
}

# Install Exa/Eza (better ls)
install_eza() {
    log_header "📁 Installing Eza (Modern ls replacement)"
    
    if command -v eza &> /dev/null; then
        log_warning "Eza already installed"
        eza --version
        return
    fi
    
    cd /tmp
    wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
    tar -xzf eza_x86_64-unknown-linux-gnu.tar.gz
    mv eza /usr/local/bin/
    rm eza_x86_64-unknown-linux-gnu.tar.gz
    
    # Add aliases to bashrc
    if ! grep -q "alias ls='eza'" $USER_HOME/.bashrc 2>/dev/null; then
        cat >> $USER_HOME/.bashrc << 'EOF'

# Eza aliases
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --icons'
EOF
    fi
    
    log_success "Eza installed"
    log_info "Use 'ls', 'll', 'la' commands with icons and colors"
}

# Install fd (better find)
install_fd() {
    log_header "🔦 Installing fd (Better find)"
    
    if command -v fd &> /dev/null || command -v fdfind &> /dev/null; then
        log_warning "fd already installed"
        return
    fi
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD fd-find
        ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true
    else
        cd /tmp
        local fd_version="9.0.0"
        wget https://github.com/sharkdp/fd/releases/download/v${fd_version}/fd-v${fd_version}-x86_64-unknown-linux-musl.tar.gz
        tar -xzf fd-v${fd_version}-x86_64-unknown-linux-musl.tar.gz
        mv fd-v${fd_version}-x86_64-unknown-linux-musl/fd /usr/local/bin/
        rm -rf fd-v${fd_version}-x86_64-unknown-linux-musl*
    fi
    
    log_success "fd installed"
    log_info "Use 'fd' for intuitive file searching"
}

# Install Delta (better diff)
install_delta() {
    log_header "📊 Installing Delta (Better git diff)"
    
    if command -v delta &> /dev/null; then
        log_warning "Delta already installed"
        delta --version
        return
    fi
    
    cd /tmp
    local delta_version="0.17.0"
    wget https://github.com/dandavison/delta/releases/download/${delta_version}/delta-${delta_version}-x86_64-unknown-linux-musl.tar.gz
    tar -xzf delta-${delta_version}-x86_64-unknown-linux-musl.tar.gz
    mv delta-${delta_version}-x86_64-unknown-linux-musl/delta /usr/local/bin/
    rm -rf delta-${delta_version}-x86_64-unknown-linux-musl*
    
    # Configure git to use delta
    sudo -u $ACTUAL_USER git config --global core.pager delta
    sudo -u $ACTUAL_USER git config --global interactive.diffFilter "delta --color-only"
    sudo -u $ACTUAL_USER git config --global delta.navigate true
    sudo -u $ACTUAL_USER git config --global delta.side-by-side true
    
    log_success "Delta installed and configured for git"
}

# Install btop (better top)
install_btop() {
    log_header "📈 Installing btop++ (Resource monitor)"
    
    if command -v btop &> /dev/null; then
        log_warning "btop already installed"
        btop --version
        return
    fi
    
    cd /tmp
    local btop_version="1.3.2"
    wget https://github.com/aristocratos/btop/releases/download/v${btop_version}/btop-x86_64-linux-musl.tbz
    tar -xjf btop-x86_64-linux-musl.tbz
    cd btop
    make install
    cd /tmp
    rm -rf btop btop-x86_64-linux-musl.tbz
    
    log_success "btop++ installed"
    log_info "Run 'btop' for a beautiful resource monitor"
}

# Install lazygit
install_lazygit() {
    log_header "🌿 Installing lazygit (TUI for git)"
    
    if command -v lazygit &> /dev/null; then
        log_warning "lazygit already installed"
        lazygit --version
        return
    fi
    
    cd /tmp
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
    
    log_success "lazygit installed"
    log_info "Run 'lazygit' in a git repository for a TUI interface"
}

# Install tldr (simplified man pages)
install_tldr() {
    log_header "📚 Installing tldr (Simplified man pages)"
    
    if command -v tldr &> /dev/null; then
        log_warning "tldr already installed"
        return
    fi
    
    # Install tealdeer (Rust implementation of tldr)
    cd /tmp
    local tldr_version="1.6.1"
    wget https://github.com/dbrgn/tealdeer/releases/download/v${tldr_version}/tealdeer-linux-x86_64-musl
    chmod +x tealdeer-linux-x86_64-musl
    mv tealdeer-linux-x86_64-musl /usr/local/bin/tldr
    
    # Update cache
    sudo -u $ACTUAL_USER tldr --update
    
    log_success "tldr installed"
    log_info "Use 'tldr command' for quick examples (e.g., 'tldr tar')"
}

# Install duf (better df)
install_duf() {
    log_header "💾 Installing duf (Disk usage utility)"
    
    if command -v duf &> /dev/null; then
        log_warning "duf already installed"
        duf --version
        return
    fi
    
    cd /tmp
    local duf_version="0.8.1"
    wget https://github.com/muesli/duf/releases/download/v${duf_version}/duf_${duf_version}_linux_x86_64.tar.gz
    tar -xzf duf_${duf_version}_linux_x86_64.tar.gz
    mv duf /usr/local/bin/
    rm duf_${duf_version}_linux_x86_64.tar.gz
    
    log_success "duf installed"
    log_info "Use 'duf' for a beautiful disk usage display"
}

# Install ncdu (NCurses Disk Usage)
install_ncdu() {
    log_header "📊 Installing ncdu (Disk usage analyzer)"
    
    if command -v ncdu &> /dev/null; then
        log_warning "ncdu already installed"
        return
    fi
    
    $INSTALL_CMD ncdu
    
    log_success "ncdu installed"
    log_info "Use 'ncdu' to analyze disk usage interactively"
}

# Install httpie (better curl)
install_httpie() {
    log_header "🌐 Installing HTTPie (User-friendly HTTP client)"
    
    if command -v http &> /dev/null; then
        log_warning "HTTPie already installed"
        http --version
        return
    fi
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD httpie
    else
        # Install via pip
        if ! command -v pip3 &> /dev/null; then
            $INSTALL_CMD python3-pip
        fi
        pip3 install httpie
    fi
    
    log_success "HTTPie installed"
    log_info "Use 'http' command for API testing (e.g., 'http GET https://api.github.com')"
}

# Install jq (already in devops script, but adding advanced alternatives)
install_jq_tools() {
    log_header "🔧 Installing JSON/YAML Tools"
    
    # Install jq
    if ! command -v jq &> /dev/null; then
        $INSTALL_CMD jq
        log_success "jq installed"
    fi
    
    # Install yq (YAML processor)
    if ! command -v yq &> /dev/null; then
        cd /tmp
        local yq_version="4.40.5"
        wget https://github.com/mikefarah/yq/releases/download/v${yq_version}/yq_linux_amd64
        chmod +x yq_linux_amd64
        mv yq_linux_amd64 /usr/local/bin/yq
        log_success "yq installed"
    fi
    
    log_info "Use 'jq' for JSON and 'yq' for YAML processing"
}

# Install modern shell enhancements
install_shell_enhancements() {
    log_header "🐚 Installing Shell Enhancements"
    
    # Install tmux
    if ! command -v tmux &> /dev/null; then
        $INSTALL_CMD tmux
        log_success "tmux installed"
    fi
    
    # Install zsh (optional)
    read -p "Install Zsh shell? (y/n): " install_zsh
    if [[ $install_zsh == "y" ]]; then
        if ! command -v zsh &> /dev/null; then
            $INSTALL_CMD zsh
            log_success "Zsh installed"
            log_info "Run 'chsh -s $(which zsh)' to set as default shell"
        fi
    fi
}

# Install k9s (Kubernetes TUI)
install_k9s() {
    log_header "☸️  Installing k9s (Kubernetes TUI)"
    
    if command -v k9s &> /dev/null; then
        log_warning "k9s already installed"
        k9s version
        return
    fi
    
    cd /tmp
    K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)
    wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
    tar -xzf k9s_Linux_amd64.tar.gz
    mv k9s /usr/local/bin/
    rm k9s_Linux_amd64.tar.gz
    
    log_success "k9s installed"
    log_info "Run 'k9s' to manage Kubernetes clusters with a TUI"
}

# Create useful aliases
create_aliases() {
    log_header "🔗 Creating Useful Aliases"
    
    local alias_file="$USER_HOME/.bash_aliases"
    
    cat > $alias_file << 'EOF'
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Docker shortcuts
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'

# System shortcuts
alias update='sudo apt update && sudo apt upgrade -y' # For Debian/Ubuntu
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# Modern replacements (if installed)
command -v eza > /dev/null && alias ls='eza --icons' || alias ls='ls --color=auto'
command -v bat > /dev/null && alias cat='bat --paging=never'
command -v btop > /dev/null && alias top='btop'

# Utility aliases
alias h='history'
alias c='clear'
alias q='exit'
alias weather='curl wttr.in'
EOF
    
    chown $ACTUAL_USER:$ACTUAL_USER $alias_file
    
    # Source aliases in bashrc
    if ! grep -q ".bash_aliases" $USER_HOME/.bashrc 2>/dev/null; then
        echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >> $USER_HOME/.bashrc
    fi
    
    log_success "Aliases created in ~/.bash_aliases"
}

# Show installed tools summary
show_summary() {
    log_header "✨ Installation Summary ✨"
    
    echo -e "${CYAN}${BOLD}Installed Tools:${NC}\n"
    
    command -v fzf &> /dev/null && echo -e "${GREEN}✓${NC} FZF - Fuzzy finder"
    command -v nvim &> /dev/null && echo -e "${GREEN}✓${NC} Neovim - Modern text editor"
    command -v zoxide &> /dev/null && echo -e "${GREEN}✓${NC} Zoxide - Smart cd"
    command -v bat &> /dev/null && echo -e "${GREEN}✓${NC} Bat - Better cat"
    command -v rg &> /dev/null && echo -e "${GREEN}✓${NC} Ripgrep - Better grep"
    command -v eza &> /dev/null && echo -e "${GREEN}✓${NC} Eza - Modern ls"
    command -v fd &> /dev/null && echo -e "${GREEN}✓${NC} fd - Better find"
    command -v delta &> /dev/null && echo -e "${GREEN}✓${NC} Delta - Better git diff"
    command -v btop &> /dev/null && echo -e "${GREEN}✓${NC} btop++ - Resource monitor"
    command -v lazygit &> /dev/null && echo -e "${GREEN}✓${NC} lazygit - Git TUI"
    command -v tldr &> /dev/null && echo -e "${GREEN}✓${NC} tldr - Simplified man pages"
    command -v duf &> /dev/null && echo -e "${GREEN}✓${NC} duf - Disk usage"
    command -v ncdu &> /dev/null && echo -e "${GREEN}✓${NC} ncdu - Disk analyzer"
    command -v http &> /dev/null && echo -e "${GREEN}✓${NC} HTTPie - HTTP client"
    command -v yq &> /dev/null && echo -e "${GREEN}✓${NC} yq - YAML processor"
    command -v k9s &> /dev/null && echo -e "${GREEN}✓${NC} k9s - Kubernetes TUI"
    command -v tmux &> /dev/null && echo -e "${GREEN}✓${NC} tmux - Terminal multiplexer"
    
    echo -e "\n${YELLOW}${BOLD}Quick Tips:${NC}"
    echo "• Press Ctrl+R to search command history with FZF"
    echo "• Use 'z <directory>' to jump to frequently used directories"
    echo "• Run 'btop' for a beautiful system monitor"
    echo "• Use 'lazygit' in git repos for an interactive TUI"
    echo "• Type 'tldr <command>' for quick command examples"
    echo "• Run 'nvim' to start Neovim editor"
    echo "• Check ~/.bash_aliases for useful shortcuts"
    
    echo -e "\n${GREEN}${BOLD}Reload your shell to activate all changes:${NC}"
    echo "  source ~/.bashrc"
    echo -e "\n${CYAN}Happy hacking! 🚀${NC}\n"
}

# Interactive menu
show_menu() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║     ⚡ Advanced Linux Utilities Setup ⚡             ║
║                                                       ║
║     Modern CLI tools for power users                 ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${WHITE}Select installation option:${NC}\n"
    echo -e "${GREEN}1)${NC} Full Installation (All utilities)"
    echo -e "${GREEN}2)${NC} Essential Tools (FZF, Neovim, Bat, Ripgrep, Eza)"
    echo -e "${GREEN}3)${NC} Developer Focus (Git tools, lazygit, delta, HTTPie)"
    echo -e "${GREEN}4)${NC} System Monitor Tools (btop, duf, ncdu)"
    echo -e "${GREEN}5)${NC} Custom Installation (Choose tools)"
    echo -e "${GREEN}6)${NC} Exit"
    echo ""
}

# Full installation
full_install() {
    update_system
    install_dependencies
    install_fzf
    install_neovim
    install_zoxide
    install_bat
    install_ripgrep
    install_eza
    install_fd
    install_delta
    install_btop
    install_lazygit
    install_tldr
    install_duf
    install_ncdu
    install_httpie
    install_jq_tools
    install_k9s
    install_shell_enhancements
    create_aliases
}

# Essential installation
essential_install() {
    update_system
    install_dependencies
    install_fzf
    install_neovim
    install_bat
    install_ripgrep
    install_eza
    install_zoxide
    create_aliases
}

# Developer focus
developer_install() {
    update_system
    install_dependencies
    install_fzf
    install_neovim
    install_lazygit
    install_delta
    install_httpie
    install_jq_tools
    install_ripgrep
    install_fd
    create_aliases
}

# System monitor focus
monitor_install() {
    update_system
    install_dependencies
    install_btop
    install_duf
    install_ncdu
    $INSTALL_CMD htop iotop
    create_aliases
}

# Custom installation
custom_install() {
    log_header "📋 Custom Installation"
    
    echo -e "${YELLOW}Select tools to install (y/n):${NC}\n"
    
    read -p "FZF (Fuzzy Finder)? (y/n): " c_fzf
    read -p "Neovim? (y/n): " c_nvim
    read -p "Zoxide (Smart cd)? (y/n): " c_zoxide
    read -p "Bat (Better cat)? (y/n): " c_bat
    read -p "Ripgrep (Better grep)? (y/n): " c_rg
    read -p "Eza (Modern ls)? (y/n): " c_eza
    read -p "fd (Better find)? (y/n): " c_fd
    read -p "Delta (Git diff)? (y/n): " c_delta
    read -p "btop++ (Resource monitor)? (y/n): " c_btop
    read -p "lazygit (Git TUI)? (y/n): " c_lazygit
    read -p "tldr (Simplified man)? (y/n): " c_tldr
    read -p "duf (Disk usage)? (y/n): " c_duf
    read -p "ncdu (Disk analyzer)? (y/n): " c_ncdu
    read -p "HTTPie (HTTP client)? (y/n): " c_httpie
    read -p "jq/yq (JSON/YAML tools)? (y/n): " c_jq
    read -p "k9s (Kubernetes TUI)? (y/n): " c_k9s
    read -p "Shell enhancements (tmux, etc)? (y/n): " c_shell
    
    update_system
    install_dependencies
    
    [[ $c_fzf == "y" ]] && install_fzf
    [[ $c_nvim == "y" ]] && install_neovim
    [[ $c_zoxide == "y" ]] && install_zoxide
    [[ $c_bat == "y" ]] && install_bat
    [[ $c_rg == "y" ]] && install_ripgrep
    [[ $c_eza == "y" ]] && install_eza
    [[ $c_fd == "y" ]] && install_fd
    [[ $c_delta == "y" ]] && install_delta
    [[ $c_btop == "y" ]] && install_btop
    [[ $c_lazygit == "y" ]] && install_lazygit
    [[ $c_tldr == "y" ]] && install_tldr
    [[ $c_duf == "y" ]] && install_duf
    [[ $c_ncdu == "y" ]] && install_ncdu
    [[ $c_httpie == "y" ]] && install_httpie
    [[ $c_jq == "y" ]] && install_jq_tools
    [[ $c_k9s == "y" ]] && install_k9s
    [[ $c_shell == "y" ]] && install_shell_enhancements
    
    create_aliases
}

# Main execution
main() {
    check_privileges
    get_actual_user
    detect_os
    
    show_menu
    read -p "Enter your choice [1-6]: " choice
    
    case $choice in
        1)
            log_info "Starting full installation..."
            full_install
            ;;
        2)
            log_info "Installing essential tools..."
            essential_install
            ;;
        3)
            log_info "Installing developer tools..."
            developer_install
            ;;
        4)
            log_info "Installing system monitor tools..."
            monitor_install
            ;;
        5)
            log_info "Starting custom installation..."
            custom_install
            ;;
        6)
            log_info "Exiting..."
            exit 0
            ;;
        *)
            log_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
    
    show_summary
    
    log_info "Please run: source ~/.bashrc"
    echo -e "${GREEN}${BOLD}Installation complete! Enjoy your enhanced terminal! 🎉${NC}\n"
}

# Run main function
main
