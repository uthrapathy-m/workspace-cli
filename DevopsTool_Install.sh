#!/bin/bash

#############################################
# Robust DevOps Tools Setup Script
# Author: Your Name
# Description: Install DevOps tools with fallback to official sources
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
NC='\033[0m'

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
        ARCH=$(uname -m)
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

    log_success "Detected OS: $OS $VERSION ($ARCH)"
    log_success "Package Manager: $PKG_MANAGER"
}

# Check if running as root or with sudo
check_privileges() {
    if [ "$EUID" -ne 0 ]; then
        log_warning "This script requires sudo privileges."
        exec sudo bash "$0" "$@"
    fi
}

# Get actual user
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

# Install basic utilities
install_basics() {
    log_header "🔧 Installing Basic Utilities"
    
    local packages=""
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        packages="curl wget git vim nano unzip tar gzip build-essential software-properties-common apt-transport-https ca-certificates gnupg lsb-release jq tree htop net-tools"
    else
        packages="curl wget git vim nano unzip tar gzip gcc gcc-c++ make jq tree htop net-tools"
    fi
    
    $INSTALL_CMD $packages
    log_success "Basic utilities installed"
}

# Install Docker
install_docker() {
    log_header "🐳 Installing Docker"
    
    if command -v docker &> /dev/null; then
        log_warning "Docker already installed"
        docker --version
        return 0
    fi
    
    log_info "Attempting package manager installation..."
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        # Try official Docker repo
        curl -fsSL https://download.docker.com/linux/$OS/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 2>/dev/null || {
            log_warning "Failed to add Docker GPG key via package manager"
        }
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$OS $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt update
        $INSTALL_CMD docker-ce docker-ce-cli containerd.io docker-compose-plugin || {
            log_error "Package manager installation failed"
            log_info "Trying convenience script from official Docker..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh
            rm get-docker.sh
        }
    else
        # RHEL/CentOS/Amazon Linux
        $INSTALL_CMD yum-utils
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        $INSTALL_CMD docker-ce docker-ce-cli containerd.io docker-compose-plugin || {
            log_error "Package manager installation failed"
            log_info "Trying convenience script from official Docker..."
            curl -fsSL https://get.docker.com -o get-docker.sh
            sh get-docker.sh
            rm get-docker.sh
        }
    fi
    
    # Start and enable Docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker $ACTUAL_USER 2>/dev/null || true
    
    if command -v docker &> /dev/null; then
        log_success "Docker installed successfully"
        docker --version
        return 0
    else
        log_error "Docker installation failed"
        return 1
    fi
}

# Install Docker Compose standalone
install_docker_compose() {
    log_header "🐙 Installing Docker Compose"
    
    if command -v docker-compose &> /dev/null; then
        log_warning "Docker Compose already installed"
        docker-compose --version
        return 0
    fi
    
    log_info "Downloading from official GitHub releases..."
    
    local version="v2.24.5"
    local url="https://github.com/docker/compose/releases/download/${version}/docker-compose-linux-${ARCH}"
    
    curl -L "$url" -o /usr/local/bin/docker-compose || {
        log_error "Failed to download Docker Compose"
        return 1
    }
    
    chmod +x /usr/local/bin/docker-compose
    
    if command -v docker-compose &> /dev/null; then
        log_success "Docker Compose installed"
        docker-compose --version
        return 0
    else
        log_error "Docker Compose installation failed"
        return 1
    fi
}

# Install AWS CLI v2
install_aws_cli() {
    log_header "☁️  Installing AWS CLI v2"
    
    if command -v aws &> /dev/null; then
        log_warning "AWS CLI already installed"
        aws --version
        return 0
    fi
    
    log_info "Downloading from official AWS..."
    
    cd /tmp
    
    if [ "$ARCH" = "x86_64" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" || {
            log_error "Failed to download AWS CLI"
            return 1
        }
    elif [ "$ARCH" = "aarch64" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" || {
            log_error "Failed to download AWS CLI"
            return 1
        }
    else
        log_error "Unsupported architecture for AWS CLI: $ARCH"
        return 1
    fi
    
    unzip -q awscliv2.zip
    ./aws/install --update || ./aws/install
    rm -rf awscliv2.zip aws
    
    if command -v aws &> /dev/null; then
        log_success "AWS CLI v2 installed"
        aws --version
        return 0
    else
        log_error "AWS CLI installation failed"
        return 1
    fi
}

# Install Terraform
install_terraform() {
    log_header "🏗️  Installing Terraform"
    
    if command -v terraform &> /dev/null; then
        log_warning "Terraform already installed"
        terraform --version
        return 0
    fi
    
    log_info "Attempting HashiCorp repository installation..."
    
    # Try official repo first
    wget -O- https://apt.releases.hashicorp.com/gpg 2>/dev/null | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null || {
        log_warning "Failed to add HashiCorp GPG key"
    }
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
        apt update
        $INSTALL_CMD terraform || {
            log_warning "Repository installation failed, downloading binary..."
            install_terraform_binary
        }
    else
        yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
        $INSTALL_CMD terraform || {
            log_warning "Repository installation failed, downloading binary..."
            install_terraform_binary
        }
    fi
    
    if command -v terraform &> /dev/null; then
        log_success "Terraform installed"
        terraform --version
        return 0
    else
        log_error "Terraform installation failed"
        return 1
    fi
}

# Install Terraform binary directly
install_terraform_binary() {
    log_info "Downloading Terraform binary from official releases..."
    
    cd /tmp
    local version="1.7.5"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_${arch_name}.zip" || return 1
    unzip -o "terraform_${version}_linux_${arch_name}.zip"
    mv terraform /usr/local/bin/
    chmod +x /usr/local/bin/terraform
    rm "terraform_${version}_linux_${arch_name}.zip"
}

# Install Kubectl
install_kubectl() {
    log_header "☸️  Installing Kubectl"
    
    if command -v kubectl &> /dev/null; then
        log_warning "Kubectl already installed"
        kubectl version --client
        return 0
    fi
    
    log_info "Downloading from official Kubernetes releases..."
    
    local version=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    curl -LO "https://dl.k8s.io/release/${version}/bin/linux/${arch_name}/kubectl" || {
        log_error "Failed to download kubectl"
        return 1
    }
    
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    
    if command -v kubectl &> /dev/null; then
        log_success "Kubectl installed"
        kubectl version --client
        return 0
    else
        log_error "Kubectl installation failed"
        return 1
    fi
}

# Install Helm
install_helm() {
    log_header "⎈ Installing Helm"
    
    if command -v helm &> /dev/null; then
        log_warning "Helm already installed"
        helm version
        return 0
    fi
    
    log_info "Downloading from official Helm script..."
    
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || {
        log_error "Official script failed, trying manual download..."
        install_helm_binary
    }
    
    if command -v helm &> /dev/null; then
        log_success "Helm installed"
        helm version
        return 0
    else
        log_error "Helm installation failed"
        return 1
    fi
}

# Install Helm binary directly
install_helm_binary() {
    cd /tmp
    local version="v3.14.2"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://get.helm.sh/helm-${version}-linux-${arch_name}.tar.gz" || return 1
    tar -zxf "helm-${version}-linux-${arch_name}.tar.gz"
    mv linux-${arch_name}/helm /usr/local/bin/helm
    chmod +x /usr/local/bin/helm
    rm -rf linux-${arch_name} "helm-${version}-linux-${arch_name}.tar.gz"
}

# Install Ansible
install_ansible() {
    log_header "📜 Installing Ansible"
    
    if command -v ansible &> /dev/null; then
        log_warning "Ansible already installed"
        ansible --version
        return 0
    fi
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        add-apt-repository -y ppa:ansible/ansible 2>/dev/null || {
            log_warning "PPA failed, using pip..."
            $INSTALL_CMD python3-pip
            pip3 install ansible
            return 0
        }
        apt update
        $INSTALL_CMD ansible
    else
        $INSTALL_CMD epel-release
        $INSTALL_CMD ansible || {
            log_warning "Yum failed, using pip..."
            $INSTALL_CMD python3-pip
            pip3 install ansible
        }
    fi
    
    if command -v ansible &> /dev/null; then
        log_success "Ansible installed"
        ansible --version
        return 0
    else
        log_error "Ansible installation failed"
        return 1
    fi
}

# Install eksctl
install_eksctl() {
    log_header "🔧 Installing eksctl"
    
    if command -v eksctl &> /dev/null; then
        log_warning "eksctl already installed"
        eksctl version
        return 0
    fi
    
    log_info "Downloading from official eksctl releases..."
    
    cd /tmp
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_${arch_name}.tar.gz" | tar xz -C /tmp || {
        log_error "Failed to download eksctl"
        return 1
    }
    
    mv /tmp/eksctl /usr/local/bin
    chmod +x /usr/local/bin/eksctl
    
    if command -v eksctl &> /dev/null; then
        log_success "eksctl installed"
        eksctl version
        return 0
    else
        log_error "eksctl installation failed"
        return 1
    fi
}

# Install k9s
install_k9s() {
    log_header "☸️  Installing k9s"
    
    if command -v k9s &> /dev/null; then
        log_warning "k9s already installed"
        k9s version
        return 0
    fi
    
    log_info "Downloading from official k9s releases..."
    
    cd /tmp
    local K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)
    
    if [ -z "$K9S_VERSION" ]; then
        K9S_VERSION="v0.32.4"
    fi
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_${arch_name}.tar.gz" || {
        log_error "Failed to download k9s"
        return 1
    }
    
    tar -xzf "k9s_Linux_${arch_name}.tar.gz"
    mv k9s /usr/local/bin/
    chmod +x /usr/local/bin/k9s
    rm "k9s_Linux_${arch_name}.tar.gz" LICENSE README.md 2>/dev/null || true
    
    if command -v k9s &> /dev/null; then
        log_success "k9s installed"
        k9s version
        return 0
    else
        log_error "k9s installation failed"
        return 1
    fi
}

# Install Terraform docs
install_terraform_docs() {
    log_header "📄 Installing terraform-docs"
    
    if command -v terraform-docs &> /dev/null; then
        log_warning "terraform-docs already installed"
        terraform-docs --version
        return 0
    fi
    
    log_info "Downloading from official releases..."
    
    cd /tmp
    local version="v0.17.0"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://github.com/terraform-docs/terraform-docs/releases/download/${version}/terraform-docs-${version}-linux-${arch_name}.tar.gz" || {
        log_warning "Failed to download terraform-docs"
        return 1
    }
    
    tar -xzf "terraform-docs-${version}-linux-${arch_name}.tar.gz"
    mv terraform-docs /usr/local/bin/
    chmod +x /usr/local/bin/terraform-docs
    rm "terraform-docs-${version}-linux-${arch_name}.tar.gz" LICENSE README.md 2>/dev/null || true
    
    if command -v terraform-docs &> /dev/null; then
        log_success "terraform-docs installed"
        terraform-docs --version
        return 0
    fi
}

# Install Terragrunt
install_terragrunt() {
    log_header "🌍 Installing Terragrunt"
    
    if command -v terragrunt &> /dev/null; then
        log_warning "Terragrunt already installed"
        terragrunt --version
        return 0
    fi
    
    log_info "Downloading from official releases..."
    
    cd /tmp
    local version="v0.55.1"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/${version}/terragrunt_linux_${arch_name}" || {
        log_warning "Failed to download Terragrunt"
        return 1
    }
    
    mv "terragrunt_linux_${arch_name}" /usr/local/bin/terragrunt
    chmod +x /usr/local/bin/terragrunt
    
    if command -v terragrunt &> /dev/null; then
        log_success "Terragrunt installed"
        terragrunt --version
        return 0
    fi
}

# Install Python and pip
install_python() {
    log_header "🐍 Installing Python 3 and pip"
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        $INSTALL_CMD python3 python3-pip python3-venv
    else
        $INSTALL_CMD python3 python3-pip
    fi
    
    python3 --version
    pip3 --version
    log_success "Python 3 and pip installed"
}

# Install Node.js
install_nodejs() {
    log_header "🟢 Installing Node.js and npm"
    
    if command -v node &> /dev/null; then
        log_warning "Node.js already installed"
        node --version
        npm --version
        return 0
    fi
    
    log_info "Installing Node.js from NodeSource..."
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - || {
            log_warning "NodeSource repo failed, trying direct install..."
            $INSTALL_CMD nodejs npm
        }
        $INSTALL_CMD nodejs
    else
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - || {
            log_warning "NodeSource repo failed, trying direct install..."
            $INSTALL_CMD nodejs npm
        }
        $INSTALL_CMD nodejs
    fi
    
    if command -v node &> /dev/null; then
        log_success "Node.js and npm installed"
        node --version
        npm --version
        return 0
    else
        log_error "Node.js installation failed"
        return 1
    fi
}

# Install Go
install_go() {
    log_header "🔷 Installing Go"
    
    if command -v go &> /dev/null; then
        log_warning "Go already installed"
        go version
        return 0
    fi
    
    log_info "Downloading from official Go releases..."
    
    cd /tmp
    local version="1.22.1"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://go.dev/dl/go${version}.linux-${arch_name}.tar.gz" || {
        log_error "Failed to download Go"
        return 1
    }
    
    rm -rf /usr/local/go
    tar -C /usr/local -xzf "go${version}.linux-${arch_name}.tar.gz"
    rm "go${version}.linux-${arch_name}.tar.gz"
    
    # Add to PATH
    if ! grep -q "/usr/local/go/bin" $USER_HOME/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> $USER_HOME/.bashrc
        export PATH=$PATH:/usr/local/go/bin
    fi
    
    if command -v go &> /dev/null; then
        log_success "Go installed"
        go version
        return 0
    else
        log_error "Go installation failed"
        return 1
    fi
}

# Install Jenkins
install_jenkins() {
    log_header "🔨 Installing Jenkins"
    
    if systemctl is-active --quiet jenkins 2>/dev/null || command -v jenkins &> /dev/null; then
        log_warning "Jenkins already installed"
        return 0
    fi
    
    log_info "Installing Jenkins from official repository..."
    
    # Install Java (required for Jenkins)
    if ! command -v java &> /dev/null; then
        log_info "Installing Java (Jenkins dependency)..."
        if [ "$PKG_MANAGER" = "apt" ]; then
            $INSTALL_CMD fontconfig openjdk-17-jre
        else
            $INSTALL_CMD fontconfig java-17-openjdk
        fi
    fi
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        # Add Jenkins repo
        curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee \
            /usr/share/keyrings/jenkins-keyring.asc > /dev/null
        echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
            https://pkg.jenkins.io/debian-stable binary/ | tee \
            /etc/apt/sources.list.d/jenkins.list > /dev/null
        apt update
        $INSTALL_CMD jenkins || {
            log_error "Package manager installation failed"
            return 1
        }
    else
        # RHEL/CentOS/Amazon Linux
        wget -O /etc/yum.repos.d/jenkins.repo \
            https://pkg.jenkins.io/redhat-stable/jenkins.repo || {
            log_error "Failed to add Jenkins repo"
            return 1
        }
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
        $INSTALL_CMD jenkins || {
            log_error "Package manager installation failed"
            return 1
        }
    fi
    
    # Start and enable Jenkins
    systemctl daemon-reload
    systemctl enable jenkins
    systemctl start jenkins
    
    # Wait for Jenkins to start
    log_info "Waiting for Jenkins to start..."
    sleep 10
    
    if systemctl is-active --quiet jenkins; then
        log_success "Jenkins installed and started"
        log_info "Access Jenkins at: http://localhost:8080"
        log_info "Initial admin password location: /var/lib/jenkins/secrets/initialAdminPassword"
        if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
            log_warning "Initial admin password: $(cat /var/lib/jenkins/secrets/initialAdminPassword)"
        fi
        return 0
    else
        log_error "Jenkins installation completed but service failed to start"
        return 1
    fi
}

# Install Minikube
install_minikube() {
    log_header "🎡 Installing Minikube"
    
    if command -v minikube &> /dev/null; then
        log_warning "Minikube already installed"
        minikube version
        return 0
    fi
    
    log_info "Downloading from official Minikube releases..."
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${arch_name}" || {
        log_error "Failed to download Minikube"
        return 1
    }
    
    install minikube-linux-${arch_name} /usr/local/bin/minikube
    rm minikube-linux-${arch_name}
    
    if command -v minikube &> /dev/null; then
        log_success "Minikube installed"
        minikube version
        log_info "Start Minikube with: minikube start"
        return 0
    else
        log_error "Minikube installation failed"
        return 1
    fi
}

# Install Prometheus
install_prometheus() {
    log_header "📊 Installing Prometheus"
    
    if command -v prometheus &> /dev/null; then
        log_warning "Prometheus already installed"
        prometheus --version
        return 0
    fi
    
    log_info "Downloading from official Prometheus releases..."
    
    cd /tmp
    local version="2.50.1"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://github.com/prometheus/prometheus/releases/download/v${version}/prometheus-${version}.linux-${arch_name}.tar.gz" || {
        log_error "Failed to download Prometheus"
        return 1
    }
    
    tar -xzf "prometheus-${version}.linux-${arch_name}.tar.gz"
    cd "prometheus-${version}.linux-${arch_name}"
    
    # Install binaries
    mv prometheus promtool /usr/local/bin/
    
    # Create directories
    mkdir -p /etc/prometheus
    mkdir -p /var/lib/prometheus
    
    # Copy config files
    cp -r consoles console_libraries /etc/prometheus/
    
    # Create basic config if doesn't exist
    if [ ! -f /etc/prometheus/prometheus.yml ]; then
        cat > /etc/prometheus/prometheus.yml << 'EOF'
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF
    fi
    
    # Create prometheus user
    useradd --no-create-home --shell /bin/false prometheus 2>/dev/null || true
    chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
    
    # Create systemd service
    cat > /etc/systemd/system/prometheus.service << 'EOF'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF
    
    # Cleanup
    cd /tmp
    rm -rf "prometheus-${version}.linux-${arch_name}.tar.gz" "prometheus-${version}.linux-${arch_name}"
    
    # Start and enable Prometheus
    systemctl daemon-reload
    systemctl enable prometheus
    systemctl start prometheus
    
    if command -v prometheus &> /dev/null; then
        log_success "Prometheus installed"
        prometheus --version
        log_info "Access Prometheus at: http://localhost:9090"
        log_info "Config file: /etc/prometheus/prometheus.yml"
        return 0
    else
        log_error "Prometheus installation failed"
        return 1
    fi
}

# Install Grafana
install_grafana() {
    log_header "📈 Installing Grafana"
    
    if command -v grafana-server &> /dev/null; then
        log_warning "Grafana already installed"
        grafana-server -v
        return 0
    fi
    
    log_info "Installing Grafana from official repository..."
    
    if [ "$PKG_MANAGER" = "apt" ]; then
        # Add Grafana repo
        $INSTALL_CMD -y software-properties-common
        wget -q -O /usr/share/keyrings/grafana.key https://apt.grafana.com/gpg.key
        echo "deb [signed-by=/usr/share/keyrings/grafana.key] https://apt.grafana.com stable main" | tee /etc/apt/sources.list.d/grafana.list
        apt update
        $INSTALL_CMD grafana || {
            log_error "Package manager installation failed, trying direct download..."
            install_grafana_binary
            return $?
        }
    else
        # RHEL/CentOS/Amazon Linux
        cat > /etc/yum.repos.d/grafana.repo << 'EOF'
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
        $INSTALL_CMD grafana || {
            log_error "Package manager installation failed, trying direct download..."
            install_grafana_binary
            return $?
        }
    fi
    
    # Start and enable Grafana
    systemctl daemon-reload
    systemctl enable grafana-server
    systemctl start grafana-server
    
    if command -v grafana-server &> /dev/null; then
        log_success "Grafana installed and started"
        grafana-server -v 2>&1 | head -n1
        log_info "Access Grafana at: http://localhost:3000"
        log_info "Default credentials - Username: admin, Password: admin"
        return 0
    else
        log_error "Grafana installation failed"
        return 1
    fi
}

# Install Grafana binary directly
install_grafana_binary() {
    log_info "Downloading Grafana binary from official releases..."
    
    cd /tmp
    local version="10.3.3"
    
    if [ "$ARCH" = "x86_64" ]; then
        local arch_name="amd64"
    elif [ "$ARCH" = "aarch64" ]; then
        local arch_name="arm64"
    else
        log_error "Unsupported architecture: $ARCH"
        return 1
    fi
    
    wget "https://dl.grafana.com/oss/release/grafana-${version}.linux-${arch_name}.tar.gz" || {
        log_error "Failed to download Grafana"
        return 1
    }
    
    tar -xzf "grafana-${version}.linux-${arch_name}.tar.gz"
    mv "grafana-v${version}" /usr/local/grafana
    
    # Create symlinks
    ln -sf /usr/local/grafana/bin/grafana-server /usr/local/bin/grafana-server
    ln -sf /usr/local/grafana/bin/grafana-cli /usr/local/bin/grafana-cli
    
    # Create grafana user
    useradd --no-create-home --shell /bin/false grafana 2>/dev/null || true
    chown -R grafana:grafana /usr/local/grafana
    
    # Create systemd service
    cat > /etc/systemd/system/grafana-server.service << 'EOF'
[Unit]
Description=Grafana
After=network.target

[Service]
User=grafana
Group=grafana
Type=simple
WorkingDirectory=/usr/local/grafana
ExecStart=/usr/local/bin/grafana-server \
  --config=/usr/local/grafana/conf/defaults.ini \
  --homepath=/usr/local/grafana

[Install]
WantedBy=multi-user.target
EOF
    
    rm -f "grafana-${version}.linux-${arch_name}.tar.gz"
    
    systemctl daemon-reload
    systemctl enable grafana-server
    systemctl start grafana-server
}

# Configure Git
configure_git() {
    log_header "📝 Configuring Git"
    
    read -p "Enter your Git username (or press Enter to skip): " git_user
    read -p "Enter your Git email (or press Enter to skip): " git_email
    
    if [ -n "$git_user" ]; then
        sudo -u $ACTUAL_USER git config --global user.name "$git_user"
        log_success "Git username set to: $git_user"
    fi
    
    if [ -n "$git_email" ]; then
        sudo -u $ACTUAL_USER git config --global user.email "$git_email"
        log_success "Git email set to: $git_email"
    fi
}

# Interactive menu
show_menu() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║     🚀 Robust DevOps Tools Setup Script 🚀           ║
║                                                       ║
║     Install with fallback to official sources        ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${WHITE}Select installation option:${NC}\n"
    echo -e "${GREEN}1)${NC} Full Installation (All tools)"
    echo -e "${GREEN}2)${NC} Container Tools (Docker, k9s)"
    echo -e "${GREEN}3)${NC} Cloud Tools (AWS CLI, Terraform, eksctl)"
    echo -e "${GREEN}4)${NC} Kubernetes Tools (kubectl, Helm, k9s)"
    echo -e "${GREEN}5)${NC} Programming Runtimes (Python, Node.js, Go)"
    echo -e "${GREEN}6)${NC} Custom Installation"
    echo -e "${GREEN}7)${NC} Exit"
    echo ""
}

# Full installation
full_install() {
    update_system
    install_basics
    install_docker
    install_docker_compose
    install_aws_cli
    install_terraform
    install_terragrunt
    install_terraform_docs
    install_kubectl
    install_helm
    install_eksctl
    install_k9s
    install_ansible
    install_python
    install_nodejs
    install_go
}

# Container tools
container_install() {
    update_system
    install_basics
    install_docker
    install_docker_compose
    install_k9s
}

# Cloud tools
cloud_install() {
    update_system
    install_basics
    install_aws_cli
    install_terraform
    install_terragrunt
    install_terraform_docs
    install_eksctl
}

# Kubernetes tools
k8s_install() {
    update_system
    install_basics
    install_kubectl
    install_helm
    install_k9s
    install_eksctl
}

# Programming runtimes
runtime_install() {
    update_system
    install_basics
    install_python
    install_nodejs
    install_go
}

# Custom installation
custom_install() {
    log_header "📋 Custom Installation"
    
    echo -e "${YELLOW}Select tools to install (y/n):${NC}\n"
    
    read -p "Docker? (y/n): " c_docker
    read -p "Docker Compose? (y/n): " c_compose
    read -p "AWS CLI? (y/n): " c_aws
    read -p "Terraform? (y/n): " c_terraform
    read -p "Terragrunt? (y/n): " c_terragrunt
    read -p "Terraform-docs? (y/n): " c_tfdocs
    read -p "Kubectl? (y/n): " c_kubectl
    read -p "Helm? (y/n): " c_helm
    read -p "eksctl? (y/n): " c_eksctl
    read -p "k9s? (y/n): " c_k9s
    read -p "Ansible? (y/n): " c_ansible
    read -p "Python? (y/n): " c_python
    read -p "Node.js? (y/n): " c_node
    read -p "Go? (y/n): " c_go
    
    update_system
    install_basics
    
    [[ $c_docker == "y" ]] && install_docker
    [[ $c_compose == "y" ]] && install_docker_compose
    [[ $c_aws == "y" ]] && install_aws_cli
    [[ $c_terraform == "y" ]] && install_terraform
    [[ $c_terragrunt == "y" ]] && install_terragrunt
    [[ $c_tfdocs == "y" ]] && install_terraform_docs
    [[ $c_kubectl == "y" ]] && install_kubectl
    [[ $c_helm == "y" ]] && install_helm
    [[ $c_eksctl == "y" ]] && install_eksctl
    [[ $c_k9s == "y" ]] && install_k9s
    [[ $c_ansible == "y" ]] && install_ansible
    [[ $c_python == "y" ]] && install_python
    [[ $c_node == "y" ]] && install_nodejs
    [[ $c_go == "y" ]] && install_go
}

# Main execution
main() {
    check_privileges
    get_actual_user
    detect_os
    
    show_menu
    read -p "Enter your choice [1-7]: " choice
    
    case $choice in
        1)
            log_info "Starting full installation..."
            full_install
            configure_git
            ;;
        2)
            log_info "Installing container tools..."
            container_install
            ;;
        3)
            log_info "Installing cloud tools..."
            cloud_install
            configure_git
            ;;
        4)
            log_info "Installing Kubernetes tools..."
            k8s_install
            ;;
        5)
            log_info "Installing programming runtimes..."
            runtime_install
            ;;
        6)
            log_info "Starting custom installation..."
            custom_install
            configure_git
            ;;
        7)
            log_info "Exiting..."
            exit 0
            ;;
        *)
            log_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
    
    log_header "✨ Installation Complete! ✨"
    log_success "Your DevOps workspace is ready!"
    log_info "Note: You may need to log out and back in for group changes (Docker) to take effect."
    
    echo -e "\n${CYAN}Installed Tools Summary:${NC}"
    command -v docker &>/dev/null && echo "✓ Docker: $(docker --version)"
    command -v docker-compose &>/dev/null && echo "✓ Docker Compose: $(docker-compose --version)"
    command -v aws &>/dev/null && echo "✓ AWS CLI: $(aws --version 2>&1 | head -n1)"
    command -v terraform &>/dev/null && echo "✓ Terraform: $(terraform --version | head -n1)"
    command -v terragrunt &>/dev/null && echo "✓ Terragrunt: $(terragrunt --version)"
    command -v terraform-docs &>/dev/null && echo "✓ Terraform-docs: $(terraform-docs --version)"
    command -v kubectl &>/dev/null && echo "✓ Kubectl: $(kubectl version --client --short 2>/dev/null | head -n1)"
    command -v helm &>/dev/null && echo "✓ Helm: $(helm version --short)"
    command -v eksctl &>/dev/null && echo "✓ eksctl: $(eksctl version)"
    command -v k9s &>/dev/null && echo "✓ k9s: $(k9s version --short 2>/dev/null | head -n1)"
    command -v ansible &>/dev/null && echo "✓ Ansible: $(ansible --version | head -n1)"
    command -v python3 &>/dev/null && echo "✓ Python: $(python3 --version)"
    command -v node &>/dev/null && echo "✓ Node.js: $(node --version)"
    command -v npm &>/dev/null && echo "✓ npm: $(npm --version)"
    command -v go &>/dev/null && echo "✓ Go: $(go version)"
    
    echo -e "\n${YELLOW}${BOLD}Post-Installation Steps:${NC}"
    echo "1. Log out and back in to apply Docker group membership"
    echo "2. Run 'source ~/.bashrc' to update PATH (for Go)"
    echo "3. Configure AWS CLI: 'aws configure'"
    echo "4. Test Docker: 'docker run hello-world'"
    echo "5. Test kubectl: 'kubectl version --client'"
    
    echo -e "\n${GREEN}${BOLD}Happy DevOps! 🚀${NC}\n"
}

# Run main function
main