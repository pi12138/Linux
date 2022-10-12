#!/bin/bash
set -e

if [ $PYENV_HOME ]; then
	pyenv_home=$PYENV_HOME
else
	pyenv_home="https://github.com/pyenv/pyenv.git"
fi

if [ $PYENV_VIRTUALENV_HOME ]; then
	pyenv_virtualenv_home=$PYENV_VIRTUALENV_HOME
else
    pyenv_virtualenv_home="https://github.com/pyenv/pyenv-virtualenv.git"
fi

echo $pyenv_home
echo $pyenv_virtualenv_home


git clone $pyenv_home ~/.pyenv && echo '下载 pyenv 成功'
git clone $pyenv_virtualenv_home ~/.pyenv/plugins/pyenv-virtualenv

echo >> ~/.zshrc
echo '# pyenv settings' >> ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
echo '配置 pyenv 完成'
