#!/bin/bash

# Pyenv 自动安装脚本
# 支持系统: Ubuntu/Debian, CentOS/RHEL/Fedora, macOS
# 作者: Assistant
# 版本: 1.0

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            OS="debian"
            log_info "检测到 Debian/Ubuntu 系统"
        elif [ -f /etc/redhat-release ]; then
            OS="redhat"
            log_info "检测到 RedHat/CentOS/Fedora 系统"
        else
            OS="linux"
            log_warning "未能确定具体 Linux 发行版，使用通用安装方式"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        log_info "检测到 macOS 系统"
    else
        log_error "不支持的操作系统: $OSTYPE"
        exit 1
    fi
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 安装依赖包
install_dependencies() {
    log_info "安装 pyenv 依赖包..."
    
    case $OS in
        "debian")
            sudo apt update
            sudo apt install -y make build-essential libssl-dev zlib1g-dev \
                libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
                libncurses5-dev libncursesw5-dev xz-utils tk-dev \
                libffi-dev liblzma-dev python3-openssl git
            ;;
        "redhat")
            if command_exists dnf; then
                PKG_MANAGER="dnf"
            elif command_exists yum; then
                PKG_MANAGER="yum"
            else
                log_error "未找到包管理器 (dnf 或 yum)"
                exit 1
            fi
            
            sudo $PKG_MANAGER groupinstall -y "Development Tools"
            sudo $PKG_MANAGER install -y gcc openssl-devel bzip2-devel \
                libffi-devel readline-devel sqlite-devel xz-devel \
                zlib-devel findutils git curl wget
            ;;
        "macos")
            if ! command_exists brew; then
                log_info "安装 Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            # 安装 Xcode 命令行工具
            if ! xcode-select -p >/dev/null 2>&1; then
                log_info "安装 Xcode 命令行工具..."
                xcode-select --install
                log_warning "请在 Xcode 安装完成后重新运行此脚本"
                exit 0
            fi
            
            brew install openssl readline sqlite3 xz zlib tcl-tk git
            ;;
    esac
    
    log_success "依赖包安装完成"
}

# 安装 pyenv
install_pyenv() {
    log_info "安装 pyenv..."
    
    # 设置 pyenv 安装路径
    PYENV_ROOT="$HOME/.pyenv"
    
    # 如果已存在，询问是否覆盖
    if [ -d "$PYENV_ROOT" ]; then
        log_warning "pyenv 已存在于 $PYENV_ROOT"
        read -p "是否要重新安装? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "删除现有 pyenv 安装..."
            rm -rf "$PYENV_ROOT"
        else
            log_info "跳过 pyenv 安装"
            return 0
        fi
    fi
    
    # 克隆 pyenv 仓库
    log_info "从 GitHub 克隆 pyenv..."
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
    
    # 安装 pyenv-virtualenv 插件
    log_info "安装 pyenv-virtualenv 插件..."
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
    
    # 安装 pyenv-update 插件
    log_info "安装 pyenv-update 插件..."
    git clone https://github.com/pyenv/pyenv-update.git "$PYENV_ROOT/plugins/pyenv-update"
    
    log_success "pyenv 安装完成"
}

# 配置环境变量
configure_shell() {
    log_info "配置 shell 环境..."
    
    PYENV_ROOT="$HOME/.pyenv"
    
    # 检测当前 shell
    CURRENT_SHELL=$(basename "$SHELL")
    
    case $CURRENT_SHELL in
        "bash")
            SHELL_RC="$HOME/.bashrc"
            PROFILE="$HOME/.bash_profile"
            ;;
        "zsh")
            SHELL_RC="$HOME/.zshrc"
            PROFILE="$HOME/.zprofile"
            ;;
        "fish")
            SHELL_RC="$HOME/.config/fish/config.fish"
            PROFILE=""
            ;;
        *)
            log_warning "未识别的 shell: $CURRENT_SHELL，使用 .bashrc"
            SHELL_RC="$HOME/.bashrc"
            PROFILE="$HOME/.bash_profile"
            ;;
    esac
    
    # 备份现有配置文件
    if [ -f "$SHELL_RC" ]; then
        cp "$SHELL_RC" "${SHELL_RC}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "已备份 $SHELL_RC"
    fi
    
    # 添加 pyenv 配置
    if [[ $CURRENT_SHELL == "fish" ]]; then
        # Fish shell 配置
        mkdir -p "$(dirname "$SHELL_RC")"
        cat >> "$SHELL_RC" << 'EOF'

# Pyenv configuration
set -gx PYENV_ROOT $HOME/.pyenv
set -gx PATH $PYENV_ROOT/bin $PATH
pyenv init - | source
pyenv virtualenv-init - | source
EOF
    else
        # Bash/Zsh 配置
        cat >> "$SHELL_RC" << 'EOF'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
        
        # 对于 macOS，也需要配置 profile
        if [[ $OS == "macos" && -n "$PROFILE" ]]; then
            cat >> "$PROFILE" << 'EOF'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
        fi
    fi
    
    log_success "Shell 环境配置完成"
    log_info "配置已添加到: $SHELL_RC"
}

# 验证安装
verify_installation() {
    log_info "验证 pyenv 安装..."
    
    # 重新加载环境变量
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    
    if command_exists pyenv; then
        PYENV_VERSION=$("$PYENV_ROOT/bin/pyenv" --version)
        log_success "pyenv 安装成功: $PYENV_VERSION"
        
        # 显示可用的 Python 版本（前10个）
        log_info "可用的 Python 版本 (显示前10个):"
        "$PYENV_ROOT/bin/pyenv" install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | head -10
        
        return 0
    else
        log_error "pyenv 安装失败或环境变量未正确配置"
        return 1
    fi
}

# 安装常用 Python 版本
install_python_versions() {
    read -p "是否要安装常用的 Python 版本? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return 0
    fi
    
    PYENV_ROOT="$HOME/.pyenv"
    PYTHON_VERSIONS=("3.11.8" "3.10.13" "3.9.18")
    
    for version in "${PYTHON_VERSIONS[@]}"; do
        log_info "安装 Python $version..."
        if "$PYENV_ROOT/bin/pyenv" install "$version"; then
            log_success "Python $version 安装完成"
        else
            log_error "Python $version 安装失败"
        fi
    done
    
    # 设置全局默认版本
    if [[ ${#PYTHON_VERSIONS[@]} -gt 0 ]]; then
        log_info "设置 Python ${PYTHON_VERSIONS[0]} 为全局默认版本"
        "$PYENV_ROOT/bin/pyenv" global "${PYTHON_VERSIONS[0]}"
    fi
}

# 显示使用说明
show_usage() {
    log_info "pyenv 安装完成！使用说明："
    echo
    echo "重新加载 shell 环境:"
    echo "  source ~/.bashrc  # 或 ~/.zshrc"
    echo
    echo "常用 pyenv 命令:"
    echo "  pyenv install --list          # 查看可安装的 Python 版本"
    echo "  pyenv install 3.11.8          # 安装 Python 3.11.8"
    echo "  pyenv versions                 # 查看已安装的版本"
    echo "  pyenv global 3.11.8           # 设置全局默认版本"
    echo "  pyenv local 3.10.13           # 设置当前目录使用的版本"
    echo "  pyenv virtualenv 3.11.8 myenv # 创建虚拟环境"
    echo "  pyenv activate myenv           # 激活虚拟环境"
    echo "  pyenv deactivate               # 退出虚拟环境"
    echo "  pyenv update                   # 更新 pyenv"
    echo
    log_warning "请运行 'source ~/.bashrc' 或重新打开终端以使用 pyenv"
}

# 主函数
main() {
    echo "=================================="
    echo "     Pyenv 自动安装脚本"
    echo "=================================="
    echo
    
    # 检查是否为 root 用户
    if [[ $EUID -eq 0 ]]; then
        log_error "请不要使用 root 用户运行此脚本"
        exit 1
    fi
    
    # 检测操作系统
    detect_os
    
    # 检查 Git 是否已安装
    if ! command_exists git; then
        log_error "Git 未安装，请先安装 Git"
        exit 1
    fi
    
    # 安装依赖
    install_dependencies
    
    # 安装 pyenv
    install_pyenv
    
    # 配置 shell 环境
    configure_shell
    
    # 验证安装
    if verify_installation; then
        # 安装常用 Python 版本
        install_python_versions
        
        # 显示使用说明
        show_usage
        
        log_success "pyenv 安装和配置完成！"
    else
        log_error "安装验证失败，请检查错误信息"
        exit 1
    fi
}

# 运行主函数
main "$@"
