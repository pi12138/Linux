#!/bin/bash
set -e

if [ $OHMYZSH_HOME ]; then
	ohmyzsh_home=$OHMYZSH_HOME
else
	ohmyzsh_home="https://github.com/ohmyzsh/ohmyzsh.git"
fi

if [ $ZSH_AUTOSUGGESTIONS_HOME ]; then
	zsh_autosuggestions_home=$ZSH_AUTOSUGGESTIONS_HOME
else
    zsh_autosuggestions_home="https://github.com/zsh-users/zsh-autosuggestions.git"
fi

if [ $ZSH_SYNTAX_HIGHLIGHTING_HOME ]; then
    zsh_syntax_highlighting_home=$ZSH_SYNTAX_HIGHLIGHTING_HOME
else
    zsh_syntax_highlighting_home="https://github.com/zsh-users/zsh-syntax-highlighting.git"
fi

echo $ohmyzsh_home
echo $zsh_autosuggestions_home
echo $zsh_syntax_highlighting_home

echo '开始从 github 下载 oh-my-zsh'
git clone $ohmyzsh_home ~/.oh-my-zsh && echo '下载 oh-my-zsh 完成'
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && echo '创建 zshrc 成功'


echo '开始为 oh-my-zsh 安装插件'
git clone $zsh_autosuggestions_home ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && echo '下载 zsh-autosuggestions 完成'
git clone $zsh_syntax_highlighting_home ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && echo '下载 zsh-syntax-highlighting 完成'
echo 'ZSH_THEME="ys"' >> ~/.zshrc && echo '修改主题为 ys'
echo 'plugins=(
    git
    extract
    zsh-autosuggestions
    zsh-syntax-highlighting
)' >> ~/.zshrc && echo '装载插件成功'
echo 'source $ZSH/oh-my-zsh.sh' >> ~/.zshrc

echo '开始安装 oh-my-zsh'
sudo apt install zsh -y && echo '安装 zsh 成功'
chsh -s /bin/zsh && echo '切换 zsh 为默认 shell'
echo '请重新登录查看效果'