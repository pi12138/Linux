-- vim.o.tabstop = 4
-- vim.bo.tabstop = 4
-- vim.o.softtabstop = 4
-- vim.o.shiftround = true
--  vim.o.expandtab = true
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.wo.cursorline = true
-- vim.wo.signcolumn = "yes"

-- 显示行数
vim.o.number = true

-- 设置 leader 键为空格
vim.g.mapleader = " "


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
vim.opt.showmode = false -- we are experienced, wo don't need the "-- INSERT --" mode hint


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
