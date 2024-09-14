

-- keybindings
local opt = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>v", "<C-w>v", MergeTables(opt, {desc = "向右分割"}))


if rawget(package.loaded, "plugins-config.nvim-tree") then
    -- 文件浏览器相关

    -- vim.keymap.set("n", "<A-b>", ":NvimTreeToggle<CR>", opt)         -- 光标移动到文件浏览器
    vim.keymap.set("n", "<A-f>", ":NvimTreeFindFile<CR>", opt)      -- 定位文件，光标移动到当前文件位置
    vim.keymap.set("i", "<A-p>", "<Esc>:NvimTreeFindFile<CR>", opt)
    vim.keymap.set("n", "<F5>", ":NvimTreeRefresh<CR>", opt)     -- 刷新文件树
else
    DebugNotify("没有开启 nvim-tree 不进行快捷键设置")
end

-- 文件操作相关
vim.keymap.set("i", "<C-s>", "<ESC>:w<CR>", opt)
-- vim.keymap.set("i", "<C-q>", "<ESC>:wq<CR>", opt)
vim.keymap.set("i", "<C-w>", "<ESC>:w<CR>:bd<CR>", opt)
vim.keymap.set("i", "<A-Left>", "<ESC>:BufferLineCyclePrev<CR>", opt)
vim.keymap.set("i", "<A-Right>", "<ESC>:BufferLineCycleNext<CR>", opt)
vim.keymap.set("n", "<C-s>", ":w<CR>", opt)
-- vim.keymap.set("n", "<C-q>", ":q<CR>", opt)
vim.keymap.set("n", "<A-Left>", ":BufferLineCyclePrev<CR>", opt)
vim.keymap.set("n", "<A-Right>", ":BufferLineCycleNext<CR>", opt)

-- 快速移动光标
vim.keymap.set('n', "<C-Up>", "5k", opt)
vim.keymap.set('n', "<C-Down>", "5j", opt)


-- 搜索文件
if  rawget(package.loaded, "plugins-config.telescope") then
    local teleBuilt = require("telescope.builtin")
    vim.keymap.set("i", "<C-p>", teleBuilt.find_files, opt)
    vim.keymap.set("n", "<C-p>", teleBuilt.find_files, {})
    vim.keymap.set('v', '<C-f>', teleBuilt.grep_string, opt)
    -- open file_browser with the path of the current buffer
    vim.keymap.set("n", "<C-b>", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", MergeTables(opt, {desc="file browser"}))

    -- lsp picker
    local mode = "n"
    vim.keymap.set(mode, "<leader><F12>", teleBuilt.lsp_definitions, { desc = "转到定义[f12]"})
    vim.keymap.set(mode, '<leader><F24>', teleBuilt.lsp_references, {desc = "查看引用[shift+f12]"}) -- <F24> shift + F12         查看引用
    -- vim.keymap.set(mode, '<leader><F60>', vim.lsp.buf.hover, opts) -- <F60> alt + F12                快速查看定义,以弹窗形式
    vim.keymap.set(mode, '<leader><F36>', teleBuilt.lsp_implementations, {desc = "转到实现[ctrl+f12]"}) -- <F36> ctrl + F12      转到实现
    vim.keymap.set(mode, '<leader><F11>', function() teleBuilt.diagnostics({bufnr=0}) end, {desc="查看当前buffer诊断信息[f11]"})
    vim.keymap.set(mode, '<leader><F23>', teleBuilt.diagnostics, {desc="查看当前buffer诊断信息[shift+f11]"})

    -- 全局搜索, 需要 ripgrep  支持
    if BinaryExists('rg') then
        -- vim.keymap.set("n", "<C-f>", teleBuilt.live_grep, opt)
        vim.keymap.set("n", "<C-f>", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opt)
    else
        DebugNotify("rg  不存在,不设置快捷键  Ctrl +  f")
    end
else
    DebugNotify("没有开启 telescope 不进行设置")
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

    if rawget(package.loaded, "lspsaga") then
        local mode = 'n'
        vim.keymap.set(mode, '<Leader>c', "<cmd>Lspsaga code_action<cr>", MergeTables(opts, {desc = "Code Action(lspsaga)"}))
        vim.keymap.set(mode, '<F12>', "<cmd>Lspsaga goto_definition<cr>", MergeTables(opts, {desc = "转到定义(lspsaga)"}))
        vim.keymap.set(mode, '<F60>', "<cmd>Lspsaga hover_doc<cr>", MergeTables(opts, {desc = "快速查看定义,以弹窗形式(lspsaga)"}))
        vim.keymap.set(mode, '<F24>', "<cmd>Lspsaga finder ref<cr>", MergeTables(opts, {desc = "查看引用(lspsaga)"}))
        vim.keymap.set(mode, '<F36>', "<cmd>Lspsaga finder imp<cr>", MergeTables(opts, {desc = "转到实现(lspsaga)"}))
        vim.keymap.set(mode, '<F11>', "<cmd>Lspsaga show_buf_diagnostics<cr>", MergeTables(opts, {desc = "转到实现(lspsaga)"}))
        vim.keymap.set(mode, '<F2>', vim.lsp.buf.rename, opts) 
        vim.keymap.set(mode, '<A-F>', vim.lsp.buf.format, opts)

        mode = 'i'
        vim.keymap.set(mode, '<Leader>c', "<cmd>Lspsaga code_action<cr>", MergeTables(opts, {desc = "Code Action(lspsaga)"}))
        vim.keymap.set(mode, '<F12>', "<cmd>Lspsaga goto_definition<cr>", MergeTables(opts, {desc = "转到定义(lspsaga)"}))
        vim.keymap.set(mode, '<F60>', "<cmd>Lspsaga hover_doc<cr>", MergeTables(opts, {desc = "快速查看定义,以弹窗形式(lspsaga)"}))
        vim.keymap.set(mode, '<F24>', "<cmd>Lspsaga finder ref<cr>", MergeTables(opts, {desc = "查看引用(lspsaga)"}))
        vim.keymap.set(mode, '<F36>', "<cmd>Lspsaga finder imp<cr>", MergeTables(opts, {desc = "转到实现(lspsaga)"}))
        vim.keymap.set(mode, '<F2>', vim.lsp.buf.rename, opts) 
    else
        local mode = 'n'
        vim.keymap.set(mode, '<F12>', vim.lsp.buf.definition, opts) -- F12                       转到定义
        vim.keymap.set(mode, '<F24>', vim.lsp.buf.references, opts) -- <F24> shift + F12         查看引用
        vim.keymap.set(mode, '<F60>', vim.lsp.buf.hover, opts) -- <F60> alt + F12                快速查看定义,以弹窗形式
        vim.keymap.set(mode, '<F36>', vim.lsp.buf.implementation, opts) -- <F36> ctrl + F12      转到实现
        vim.keymap.set(mode, '<F48>', vim.lsp.buf.declaration, opts) -- <F48> ctrl + shift + F12 转到盛名
        vim.keymap.set(mode, '<F2>', vim.lsp.buf.rename, opts) 
        vim.keymap.set(mode, '<A-F>', vim.lsp.buf.format, opts)
        vim.keymap.set(mode, '<Leader>c', vim.lsp.buf.code_action, MergeTables(opts, {desc = "Code Action"}))
        mode = 'i'
        vim.keymap.set(mode, '<F12>', vim.lsp.buf.definition, opts) -- F12                       转到定义
        vim.keymap.set(mode, '<F24>', vim.lsp.buf.references, opts) -- <F24> shift + F12         查看引用
        vim.keymap.set(mode, '<F60>', vim.lsp.buf.hover, opts) -- <F60> alt + F12                快速查看定义,以弹窗形式
        vim.keymap.set(mode, '<F36>', vim.lsp.buf.implementation, opts) -- <F36> ctrl + F12      转到实现
        vim.keymap.set(mode, '<F48>', vim.lsp.buf.declaration, opts) -- <F48> ctrl + shift + F12 转到盛名
        vim.keymap.set(mode, '<F2>', vim.lsp.buf.rename, opts)
    end
    vim.keymap.del('n', 'K', opts)
end

-- which-key 管理快捷键
local status, wk = pcall(require, "which-key")
if  not status  then
    DebugNotify("which-key not install.")
end

wk.add({
    -- leader
    {"<leader>qa", "<cmd>qa<cr>", desc="退出"},
    {"<leader>Q", "<cmd>qa<cr>", desc="退出"},
    {"<leader>qb", "<cmd>bd<cr>", desc="关闭当前 buffer"},
    {"<leader>?", function ()
        wk.show()
    end, desc="展示所有的快捷键"},

    -- Ctrl
    {"<C-j>", "<esc>o", desc="Into next line", mode='i'},
    {"<C-c>", "<esc>yya", desc="Copy", mode="i"},
    {"<C-x>", "<esc>dda", desc="Cut", mode="i"},
    {"<C-v>", "<esc>pa", desc="Paste", mode="i"},
})

local gsstatus, gitsigns = pcall(require, "gitsigns")
if not gsstatus then
    DebugNotify("gitsigns not install.")
else
    wk.add({
        {"<leader>gr", function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc="丢弃更改", mode="v"},
        {"<leader>gp", gitsigns.preview_hunk_inline, desc="预览当前块更改"},
        {"<leader>gi", function ()
            gitsigns.blame_line{full=true}
        end, desc = "显示当前行的修改信息"},
        {"<leader>gd", gitsigns.diffthis, desc="显示和上个版本的diff"},
    })
end
