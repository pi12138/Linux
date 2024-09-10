#!/bin/bash

# for ubuntu


# neovim provider
if command -v pip &> /dev/null; then
    echo "pip 已安装"
else
    sudo apt install python3-pip
    echo "pip 安装完成"
fi

if pip show neovim &> /dev/null; then
    echo "python neovim package 已安装"
else
    pip install neovim
    echo "neovim package 安装完成"
fi

if command -v nvm &> /dev/null; then
    echo "nvm 已安装"
else
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    source $HOME/.zshrc
    ehco "nvm 安装完成"
fi

if command -v npm &> /dev/null; then
    echo "npm 已安装"
else
    nvm install --lts
    echo "npm 已安装"
fi

if npm list -g neovim &> /dev/null; then
    echo "npm package neovim 已安装"
else 
    npm install -g neovim
    echo "npm package neovim 安装完成"
fi

# Lazy.nvim
sudo apt install luarocks

# telescope
sudo apt install ripgrep fd-find

# tree-sitter
if command -v tree-sitter &> /dev/null; then
    echo "tree-sitter 已安装"
else
    wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.23.0/tree-sitter-linux-x64.gz
    gzip -d tree-sitter-linux-x64.gz
    chmod +x tree-sitter-linux-x64

    bin_path=$HOME/.local/share/nvim/bin
    mkdir -p $bin_path
    mv ./tree-sitter-linux-x64 $bin_path/tree-sitter
    sudo ln -sf $bin_path/tree-sitter /usr/bin/tree-sitter
    echo "tree-sitter 安装完成"
fi
