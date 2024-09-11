return {
    {
	    "folke/which-key.nvim",
	    tag = "v3.13.2",
        -- keys = {
        --     {
        --         "<leader>?",
        --         function()
        --             require("which-key").show({global = false})
        --         end,
        --         desc = "Buffer Local Keymaps (which-key)"
        --     }
        -- }
    },
    { "folke/neoconf.nvim", cmd = "Neoconf" },
    "folke/neodev.nvim", 
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {}},
    -- lazy.nvim
    --[[ {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    }, ]]
    { 'echasnovski/mini.icons', version = false },  --  optional for which-key
--     {
--         "folke/trouble.nvim",
--         opts = {}, -- for default options, refer to the configuration section for custom setup.
--         cmd = "Trouble",
--         keys = {
--             {
--               "<leader>xx",
--               "<cmd>Trouble diagnostics toggle<cr>",
--               desc = "Diagnostics (Trouble)",
--             },
--             {
--               "<leader>xX",
--               "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
--               desc = "Buffer Diagnostics (Trouble)",
--             },
--             {
--               "<leader>cs",
--               "<cmd>Trouble symbols toggle focus=false<cr>",
--               desc = "Symbols (Trouble)",
--             },
--             {
--               "<leader>cl",
--               "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
--               desc = "LSP Definitions / references / ... (Trouble)",
--             },
--             {
--               "<leader>xL",
--               "<cmd>Trouble loclist toggle<cr>",
--               desc = "Location List (Trouble)",
--             },
--             {
--               "<leader>xQ",
--               "<cmd>Trouble qflist toggle<cr>",
--               desc = "Quickfix List (Trouble)",
--             },
--         },
--     }
}


