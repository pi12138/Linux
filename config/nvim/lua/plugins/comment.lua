return {
    'numToStr/Comment.nvim',
    opts = {
        -- add any options here
    },
    config = function()
        require("Comment").setup()
        local  opt = { noremap = true, silent = true }
        vim.keymap.del("n", "gb", opt)
        vim.keymap.del("n", "gc", opt)
    end,
}

