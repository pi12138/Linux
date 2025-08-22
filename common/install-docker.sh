#!/bin/bash

# Docker & Docker Compose 自动安装脚本
# 支持系统: Ubuntu/Debian, CentOS/RHEL/Rocky/Alma, Fedora, macOS
# 作者: Assistant
# 版本: 2.0

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置变量
DOCKER_COMPOSE_VERSION="v2.24.6"  # 可以修改为最新版本
USER_NAME="${SUDO_USER:-$USER}"
INSTALL_DIR="/usr/local/bin"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_cmd() {
    echo -e "${CYAN}[CMD]${NC} $1"
}

# 显示横幅
show_banner() {
    echo -e "${BLUE}"
    echo "=============================================="
    echo "     🐳 Docker & Docker Compose 安装脚本"
    echo "=============================================="
    echo -e "${NC}"
    echo "支持的系统："
    echo "• Ubuntu 18.04+ / Debian 9+"
    echo "• CentOS 7+ / RHEL 7+ / Rocky Linux / AlmaLinux"
    echo "• Fedora 32+"
    echo "• macOS 10.15+"
    echo ""
}

# 检测操作系统
detect_os() {
    log_step "检测操作系统..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # 检测 Linux 发行版
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS_NAME=$NAME
            OS_VERSION=$VERSION_ID
            
            case $ID in
                ubuntu)
                    OS="ubuntu"
                    DISTRO="ubuntu"
                    ;;
                debian)
                    OS="debian"
                    DISTRO="debian"
                    ;;
                centos)
                    OS="centos"
                    DISTRO="el"
                    ;;
                rhel)
                    OS="rhel"
                    DISTRO="el"
                    ;;
                rocky)
                    OS="rocky"
                    DISTRO="el"
                    ;;
                almalinux)
                    OS="almalinux"
                    DISTRO="el"
                    ;;
                fedora)
                    OS="fedora"
                    DISTRO="fedora"
                    ;;
                *)
                    log_error "不支持的 Linux 发行版: $ID"
                    exit 1
                    ;;
            esac
        else
            log_error "无法检测 Linux 发行版"
            exit 1
        fi
        
        log_info "检测到系统: $OS_NAME $OS_VERSION"
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        OS_VERSION=$(sw_vers -productVersion)
        log_info "检测到系统: macOS $OS_VERSION"
    else
        log_error "不支持的操作系统: $OSTYPE"
        exit 1
    fi
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查是否为 root 用户
check_root() {
    if [[ $EUID -ne 0 ]] && [[ "$OS" != "macos" ]]; then
        log_error "此脚本需要 root 权限运行 (Linux)"
        log_info "请使用: sudo $0"
        exit 1
    fi
}

# 卸载旧版本 Docker
remove_old_docker() {
    log_step "检查并卸载旧版本 Docker..."
    
    case $OS in
        ubuntu|debian)
            if dpkg -l | grep -q docker; then
                log_info "发现旧版本 Docker，正在卸载..."
                apt-get remove -y docker docker-engine docker.io containerd runc docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null || true
            fi
            ;;
        centos|rhel|rocky|almalinux|fedora)
            if rpm -qa | grep -q docker; then
                log_info "发现旧版本 Docker，正在卸载..."
                if command_exists dnf; then
                    dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null || true
                else
                    yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin 2>/dev/null || true
                fi
            fi
            ;;
    esac
    
    log_success "旧版本清理完成"
}

# 安装必要的依赖包
install_dependencies() {
    log_step "安装依赖包..."
    
    case $OS in
        ubuntu|debian)
            apt-get update
            apt-get install -y \
                ca-certificates \
                curl \
                gnupg \
                lsb-release \
                software-properties-common \
                apt-transport-https
            ;;
        centos|rhel|rocky|almalinux)
            if command_exists dnf; then
                dnf install -y yum-utils device-mapper-persistent-data lvm2 curl
            else
                yum install -y yum-utils device-mapper-persistent-data lvm2 curl
            fi
            ;;
        fedora)
            dnf install -y dnf-plugins-core curl
            ;;
        macos)
            if ! command_exists brew; then
                log_info "安装 Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            ;;
    esac
    
    log_success "依赖包安装完成"
}

# 添加 Docker 官方 GPG 密钥和仓库
add_docker_repo() {
    log_step "添加 Docker 官方仓库..."
    
    case $OS in
        ubuntu|debian)
            # 添加 GPG 密钥
            install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/$OS/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            chmod a+r /etc/apt/keyrings/docker.gpg
            
            # 添加仓库
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            apt-get update
            ;;
        centos|rhel|rocky|almalinux)
            if command_exists dnf; then
                dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            else
                yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            fi
            ;;
        fedora)
            dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            ;;
    esac
    
    log_success "Docker 仓库添加完成"
}

# 安装 Docker Engine
install_docker() {
    log_step "安装 Docker Engine..."
    
    case $OS in
        ubuntu|debian)
            apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        centos|rhel|rocky|almalinux|fedora)
            if command_exists dnf; then
                dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            else
                yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            fi
            ;;
        macos)
            log_info "在 macOS 上安装 Docker Desktop..."
            if ! command_exists docker; then
                brew install --cask docker
                log_warning "请手动启动 Docker Desktop 应用程序"
                return 0
            fi
            ;;
    esac
    
    log_success "Docker Engine 安装完成"
}

# 安装独立的 Docker Compose (v2)
install_docker_compose() {
    log_step "安装 Docker Compose v2..."
    
    if [[ "$OS" == "macos" ]]; then
        log_info "macOS 上的 Docker Desktop 已包含 Docker Compose"
        return 0
    fi
    
    # 检测系统架构
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            ARCH="x86_64"
            ;;
        aarch64)
            ARCH="aarch64"
            ;;
        armv7l)
            ARCH="armv7"
            ;;
        *)
            log_error "不支持的架构: $ARCH"
            exit 1
            ;;
    esac
    
    # 下载 Docker Compose
    log_info "下载 Docker Compose $DOCKER_COMPOSE_VERSION for $ARCH..."
    curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-$ARCH" -o "$INSTALL_DIR/docker-compose"
    
    # 设置可执行权限
    chmod +x "$INSTALL_DIR/docker-compose"
    
    # 创建符号链接 (可选)
    if [ ! -L "/usr/bin/docker-compose" ]; then
        ln -sf "$INSTALL_DIR/docker-compose" /usr/bin/docker-compose
    fi
    
    log_success "Docker Compose 安装完成"
}

# 配置 Docker 服务
configure_docker_service() {
    log_step "配置 Docker 服务..."
    
    if [[ "$OS" == "macos" ]]; then
        log_info "macOS 上请手动启动 Docker Desktop"
        return 0
    fi
    
    # 启动并启用 Docker 服务
    systemctl start docker
    systemctl enable docker
    
    log_success "Docker 服务配置完成"
}

# 配置用户权限
configure_user_permissions() {
    if [[ "$OS" == "macos" ]]; then
        return 0
    fi
    
    log_step "配置用户权限..."
    
    # 创建 docker 组
    groupadd -f docker
    
    # 将用户添加到 docker 组
    if [[ -n "$USER_NAME" && "$USER_NAME" != "root" ]]; then
        usermod -aG docker "$USER_NAME"
        log_success "用户 $USER_NAME 已添加到 docker 组"
        log_warning "请注销并重新登录，或运行 'newgrp docker' 以应用组权限"
    else
        log_warning "以 root 用户运行，跳过用户权限配置"
    fi
}

# 优化 Docker 配置
optimize_docker_config() {
    log_step "优化 Docker 配置..."
    
    if [[ "$OS" == "macos" ]]; then
        return 0
    fi
    
    # 创建 Docker 配置目录
    mkdir -p /etc/docker
    
    # 创建 daemon.json 配置文件
    cat > /etc/docker/daemon.json << 'EOF'
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "storage-driver": "overlay2",
    "live-restore": true,
    "userland-proxy": false,
    "experimental": false,
    "metrics-addr": "127.0.0.1:9323",
    "default-address-pools": [
        {
            "base": "172.30.0.0/16",
            "size": 24
        }
    ]
}
EOF
    
    # 重启 Docker 服务以应用配置
    systemctl restart docker
    
    log_success "Docker 配置优化完成"
}

# 验证安装
verify_installation() {
    log_step "验证安装..."
    
    # 验证 Docker
    if command_exists docker; then
        DOCKER_VERSION=$(docker --version)
        log_success "Docker 安装成功: $DOCKER_VERSION"
    else
        log_error "Docker 安装失败"
        exit 1
    fi
    
    # 验证 Docker Compose
    if command_exists docker-compose || docker compose version >/dev/null 2>&1; then
        if command_exists docker-compose; then
            COMPOSE_VERSION=$(docker-compose --version)
        else
            COMPOSE_VERSION=$(docker compose version)
        fi
        log_success "Docker Compose 安装成功: $COMPOSE_VERSION"
    else
        log_error "Docker Compose 安装失败"
        exit 1
    fi
    
    # 测试 Docker 运行
    if [[ "$OS" != "macos" ]]; then
        log_info "测试 Docker 运行..."
        if docker run --rm hello-world >/dev/null 2>&1; then
            log_success "Docker 运行测试通过"
        else
            log_warning "Docker 运行测试失败，可能需要重新登录或启动 Docker 服务"
        fi
    fi
}

# 显示安装后信息
show_post_install_info() {
    echo
    log_success "🎉 Docker 和 Docker Compose 安装完成！"
    echo
    echo -e "${CYAN}安装信息:${NC}"
    docker --version 2>/dev/null || echo "Docker: 需要重新登录"
    if command_exists docker-compose; then
        docker-compose --version
    else
        docker compose version 2>/dev/null || echo "Docker Compose: 已安装 (集成版本)"
    fi
    echo
    echo -e "${CYAN}常用命令:${NC}"
    echo "  docker --version                    # 查看 Docker 版本"
    echo "  docker run hello-world              # 运行测试容器"
    echo "  docker ps                           # 查看运行中的容器"
    echo "  docker images                       # 查看镜像列表"
    echo "  docker-compose --version            # 查看 Compose 版本"
    echo "  docker compose up -d                # 启动 Compose 项目"
    echo "  docker system prune                 # 清理未使用的资源"
    echo
    echo -e "${CYAN}配置文件位置:${NC}"
    echo "  Docker 配置: /etc/docker/daemon.json"
    echo "  Docker 数据: /var/lib/docker/"
    echo
    if [[ "$OS" != "macos" && -n "$USER_NAME" && "$USER_NAME" != "root" ]]; then
        echo -e "${YELLOW}重要提示:${NC}"
        echo "  请注销并重新登录，或运行以下命令应用用户权限:"
        echo "  newgrp docker"
        echo
    fi
    
    if [[ "$OS" == "macos" ]]; then
        echo -e "${YELLOW}macOS 用户注意:${NC}"
        echo "  请手动启动 Docker Desktop 应用程序"
        echo
    fi
}

# 清理函数
cleanup() {
    log_info "清理临时文件..."
    # 在这里可以添加清理逻辑
}

# 错误处理
error_handler() {
    log_error "安装过程中发生错误 (退出码: $?)"
    cleanup
    exit 1
}

# 主函数
main() {
    # 设置错误处理
    trap error_handler ERR
    trap cleanup EXIT
    
    # 显示横幅
    show_banner
    
    # 检测操作系统
    detect_os
    
    # 检查权限
    check_root
    
    # 确认安装
    echo -e "${YELLOW}即将安装 Docker 和 Docker Compose${NC}"
    read -p "是否继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "安装取消"
        exit 0
    fi
    
    # 安装步骤
    remove_old_docker
    install_dependencies
    
    if [[ "$OS" != "macos" ]]; then
        add_docker_repo
    fi
    
    install_docker
    install_docker_compose
    configure_docker_service
    configure_user_permissions
    optimize_docker_config
    verify_installation
    show_post_install_info
    
    log_success "安装完成！享受 Docker 之旅 🐳"
}

# 运行主函数
main "$@"
