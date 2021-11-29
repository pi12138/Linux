git clone https://github.com.cnpmjs.org/pyenv/pyenv.git ~/.pyenv && echo '下载 pyenv 成功'
git clone https://github.com.cnpmjs.org/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

echo '\n# pyenv settings' >> ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
echo '配置 pyenv 完成'
