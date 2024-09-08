-- 设置 leader 键为空格, 会影响到在插入模式下输入空格会觉得卡顿,所以取消了
-- vim.g.mapleader = " "

-- 使用 lazy.nvim 管理插件
-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- print(lazypath)
-- print(vim.fn.stdpath("data"))
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {{ import = "plugins" }}
)

