-- 这个文件是快捷键设置

-- keybindings
local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)


-- 文件浏览器相关
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", opt)        -- 开启/关闭文件夹浏览器
-- vim.keymap.set("n", "<A-b>", ":NvimTreeToggle<CR>", opt)         -- 光标移动到文件浏览器
vim.keymap.set("n", "<A-f>", ":NvimTreeFindFile<CR>", opt)      -- 定位文件，光标移动到当前文件位置
vim.keymap.set("i", "<A-p>", "<Esc>:NvimTreeFindFile<CR>", opt)
vim.keymap.set("n", "<F5>", ":NvimTreeRefresh<Enter>", opt)     -- 刷新文件树

-- 文件操作相关
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>", opt)
-- vim.keymap.set("i", "<C-q>", "<ESC>:wq<CR>", opt)
vim.keymap.set("i", "<C-w>", "<ESC>:w<CR>:bd<CR>", opt)
vim.keymap.set("i", "<A-Left>", "<ESC>:BufferLineCyclePrev<Enter>", opt)
vim.keymap.set("i", "<A-Right>", "<ESC>:BufferLineCycleNext<Enter>", opt)
vim.keymap.set("n", "<C-s>", ":w<Enter>", opt)
-- vim.keymap.set("n", "<C-q>", ":q<Enter>", opt)
vim.keymap.set("n", "<A-Left>", ":BufferLineCyclePrev<Enter>", opt)
vim.keymap.set("n", "<A-Right>", ":BufferLineCycleNext<Enter>", opt)


-- 搜索文件
local teleBuilt = require("telescope.builtin")
vim.keymap.set("i", "<C-p>", teleBuilt.find_files, opt)
vim.keymap.set("n", "<C-p>", teleBuilt.find_files, opt)
-- 全局搜索, 需要 ripgrep  支持
if BinaryExists('rg') then
    vim.keymap.set("n", "<C-f>", teleBuilt.live_grep, opt)
else
    vim.notify("rg  不存在,不设置快捷键  Ctrl +  f")
end


-- 窗口操作相关
-- vim.keymap.set("n", "<A-h>", "<C-w>h", opt)
-- vim.keymap.set("n", "<A-l>", "<C-w>l", opt)
-- vim.keymap.set("n", "<A-k>", "<C-w>k", opt)
-- vim.keymap.set("n", "<A-j>", "<C-w>j", opt)


-- 行操作
-- vim.keymap.set("i", "<C-a>", "<C-o>0", opt)
-- vim.keymap.set("i", "<C-e>", "<C-o>$", opt)

-- 通过 <Leader> + y 复制内容到系统剪切板
vim.keymap.set("v", "<Leader>y", '"+y', { noremap = true, silent = true , desc = '复制内容到 + 寄存器'})


-- for lsp keymap
function SetLSPKeyMap(bufnr)
    local opts = { buffer = bufnr }
    local mode = 'n'
    vim.keymap.set(mode, '<F12>', vim.lsp.buf.definition, opts) -- F12                       转到定义
    vim.keymap.set(mode, '<F24>', vim.lsp.buf.references, opts) -- <F24> shift + F12         查看引用
    vim.keymap.set(mode, '<F60>', vim.lsp.buf.hover, opts) -- <F60> alt + F12                快速查看定义,以弹窗形式
    vim.keymap.set(mode, '<F36>', vim.lsp.buf.implementation, opts) -- <F36> ctrl + F12      转到实现
    vim.keymap.set(mode, '<F48>', vim.lsp.buf.declaration, opts) -- <F48> ctrl + shift + F12 转到盛名
    vim.keymap.set(mode, '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set(mode, '<Leader>c', vim.lsp.buf.code_action, opts)
    vim.keymap.set(mode, '<A-F>', vim.lsp.buf.format, opts)

    mode = 'i'
    vim.keymap.set(mode, '<F12>', vim.lsp.buf.definition, opts) -- F12                       转到定义
    vim.keymap.set(mode, '<F24>', vim.lsp.buf.references, opts) -- <F24> shift + F12         查看引用
    vim.keymap.set(mode, '<F60>', vim.lsp.buf.hover, opts) -- <F60> alt + F12                快速查看定义,以弹窗形式
    vim.keymap.set(mode, '<F36>', vim.lsp.buf.implementation, opts) -- <F36> ctrl + F12      转到实现
    vim.keymap.set(mode, '<F48>', vim.lsp.buf.declaration, opts) -- <F48> ctrl + shift + F12 转到盛名
    vim.keymap.set(mode, '<F2>', vim.lsp.buf.rename, opts)
    vim.keymap.set(mode, '<Leader>c', vim.lsp.buf.code_action, opts)
    vim.keymap.set(mode, '<A-F>', vim.lsp.buf.format, opts)
end
