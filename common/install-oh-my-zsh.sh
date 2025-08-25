#!/bin/bash

# 自动安装 Oh My Zsh 及常用插件脚本

set -e

# 1. 安装 Oh My Zsh（如果未安装）
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "正在安装 Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh 已安装，跳过安装。"
fi

# 2. 定义插件列表
PLUGINS=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  autojump
  docker
  docker-compose
)

# 3. 插件安装目录
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
PLUGIN_DIR="$ZSH_CUSTOM/plugins"

# 4. 安装插件函数
install_plugin() {
  local name=$1
  local repo=$2
  if [ ! -d "$PLUGIN_DIR/$name" ]; then
    echo "安装插件 $name ..."
    git clone "$repo" "$PLUGIN_DIR/$name"
  else
    echo "插件 $name 已安装，跳过。"
  fi
}

# 5. 安装常用插件
install_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
install_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting.git
install_plugin autojump https://github.com/wting/autojump.git

# docker 和 docker-compose 是 oh-my-zsh 自带插件，无需 clone

# 6. 修改 .zshrc 启用插件
echo "配置 .zshrc 启用插件..."

# 备份 .zshrc
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)

# 读取当前插件列表
current_plugins=$(grep '^plugins=' ~/.zshrc | head -1)

if [ -z "$current_plugins" ]; then
  # 没有找到 plugins= 行，添加一行
  echo "plugins=(${PLUGINS[*]})" >> ~/.zshrc
else
  # 替换 plugins= 行，合并已有插件和新插件，去重
  # 提取已有插件名
  existing=$(echo $current_plugins | sed -E "s/plugins=\((.*)\)/\1/")
  # 合并并去重
  merged=$(echo "$existing ${PLUGINS[*]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
  # 替换
  sed -i.bak "s/^plugins=.*/plugins=($merged)/" ~/.zshrc
fi

echo "插件配置完成。"

# 7. 提示重载配置
echo "请执行 'source ~/.zshrc' 或重启终端以使插件生效。"

exit 0
