-- 这个文件是快捷键设置

-- keybindings
local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)


-- 文件浏览器相关
-- vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", opt)        -- 开启/关闭文件夹浏览器
vim.keymap.set("n", "<A-b>", ":NvimTreeToggle<CR>", opt)         -- 光标移动到文件浏览器
vim.keymap.set("n", "<A-f>", ":NvimTreeFindFile<CR>", opt)      -- 定位文件，光标移动到当前文件位置
vim.keymap.set("i", "<A-p>", "<Esc>:NvimTreeFindFile<CR>", opt)
vim.keymap.set("n", "<F5>", ":NvimTreeRefresh<Enter>", opt)     -- 刷新文件树

-- 文件操作相关
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>", opt)
vim.keymap.set("i", "<C-q>", "<ESC>:wq<Enter>", opt)
vim.keymap.set("i", "<C-w>", "<ESC>:wq<Enter>", opt)
vim.keymap.set("i", "<A-Left>", "<ESC>:BufferLineCyclePrev<Enter>", opt)
vim.keymap.set("i", "<A-Right>", "<ESC>:BufferLineCycleNext<Enter>", opt)
vim.keymap.set("n", "<C-s>", ":w<Enter>", opt)
vim.keymap.set("n", "<C-q>", ":q<Enter>", opt)
vim.keymap.set("n", "<A-Left>", ":BufferLineCyclePrev<Enter>", opt)
vim.keymap.set("n", "<A-Right>", ":BufferLineCycleNext<Enter>", opt)
-- 搜索文件
local teleBuilt = require("telescope.builtin")
vim.keymap.set("i", "<C-p>", teleBuilt.find_files, opt)
vim.keymap.set("n", "<C-p>", teleBuilt.find_files, opt)




-- 窗口操作相关
vim.keymap.set("n", "<A-h>", "<C-w>h", opt)
vim.keymap.set("n", "<A-l>", "<C-w>l", opt)
vim.keymap.set("n", "<A-k>", "<C-w>k", opt)
vim.keymap.set("n", "<A-j>", "<C-w>j", opt)


-- 行操作
vim.keymap.set("i", "<C-a>", "<C-o>0", opt)
vim.keymap.set("i", "<C-e>", "<C-o>$", opt)

