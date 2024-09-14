return {
    "lewis6991/gitsigns.nvim",
    config = function ()
        require('gitsigns').setup({
            numhl = true,
            -- current_line_blame = true, -- 默认不在更改行显示更改人信息, 改为用快捷键查看
        })
    end,
    tag = "v0.9.0",
}
