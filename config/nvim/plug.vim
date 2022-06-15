call plug#begin()
" 默认配置文件位置
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" github 插件位置
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" 全部 github url
" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" 多个插件可以写在一行中，用 | 分割
" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" 按需加载
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" 使用指定 branch （默认应该是master）
" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" 使用指定 tag
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }


" 插件选项，详情参见 https://github.com/junegunn/vim-plug
" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" 钩子，在插件安装或者更新后，执行某些任务，用 do 来标记
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', {'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Initialize plugin system

" NERDTree文件树
Plug 'scrooloose/nerdtree'
" if has('nvim')
"   Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  " Defx git
"   Plug 'kristijanhusak/defx-git'
"   Plug 'kristijanhusak/defx-icons'
" else
"   Plug 'Shougo/defx.nvim'
"  Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif


call plug#end()
