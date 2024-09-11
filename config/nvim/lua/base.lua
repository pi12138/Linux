vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.wo.cursorline = true
-- vim.wo.signcolumn = "yes"

-- 显示行数
vim.o.number = true



-- 不使用 vim 内部寄存器，打通剪切板
-- vim.o.clipboard = 'unnamedplus'


-- copy 高亮
-- vim.api.nvim_create_autocmd({ "TextYankPost" }, {
--     pattern = { "*" },
--     callback = function()
--         vim.highlight.on_yank({
--             timeout = 300,
--         })
--     end,
-- })

-- 关闭鼠标
vim.o.mouse = ""


vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint (是否在 cmdline 中显示 INSERT 模式样式)
vim.opt.laststatus =  3 -- always and ONLY the last window
-- 始终显示最左边的 siderbar (用来显示lsp诊断信息或者其他的),并且长度设置为 1 (默认值是 auto, 非常恶心会引起一行反复横跳在 normal 模式下)
vim.opt.signcolumn =  'yes:1'
--vim.cmd([[
--let g:clipboard = {
--  \   'name': 'osc-copy',
--  \   'copy': {
--  \      '+': 'osc copy -v -l /root/osc.log',
--  \      '*': 'osc copy -v -l /root/osc.log',
--  \    },
--  \   'paste': {
--  \      '+': 'osc paste -v -l /root/osc.log',
--  \      '*': 'osc paste -v -l /root/osc.log',
--  \   },
--  \   'cache_enabled': 0,
--  \ }
--]])

-- 剪切板配置
function my_paste(reg)
    return function(lines) 
        --[ 返回 "" 寄存器的内容，用来作为 p 操作符的粘贴物 ]
        local content = vim.fn.getreg('"')
        return vim.split(content, '\n')        
    end
end


vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    -- paste = {
    --    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    --    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    -- },
    paste = {
        ['+'] = my_paste('+'),
        ['*'] = my_paste('*'),
    },
}


-- 折叠代码块操作, zc, zo
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldminlines =  100



vim.opt.termguicolors = true


-- 启动时不显示 messages 
vim.opt.shortmess:append("I")
