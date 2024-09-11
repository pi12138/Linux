--[[
-- 部分快捷键
-- hjkl 左下上右
-- ctrl+w v 分割 vim
-- 
-- y 复制
-- p 粘贴
-- d 剪切
-- 
-- e filename   打开新文件
-- sp filename  水平分割窗口打开新文件
-- vsp filename 竖直分割窗口打开新文件
--
-- source configfile 重新加载配置文件
--]]

require("base")
require("utils")
require("lazy-vim")
require("plugins-config.telescope")
require("plugins-config.folke")
require("keys")
-- require("plugins-config.nvim-tree")
require("plugins-config.nvim-treesitter")
require("plugins-config.bufferline")
require("plugins-config.lualine")
require("plugins-config.cmp")
require("plugins-config.mason")
