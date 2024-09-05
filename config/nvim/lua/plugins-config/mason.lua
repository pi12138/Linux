local status, mason = pcall(require, "mason")
if not status then
	vim.notify("没有找到 mason")
	return
end

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

local status, masonLsp = pcall(require, "mason-lspconfig")
if not status then
    vim.notify("没有找到 mason-lspconfig")
    return
end

masonLsp.setup({
    automatic_installation = true,
    ensure_installed = {
        "gopls",
        "lua_ls",
    },
})

local status, nvimLsp = pcall(require, "lspconfig")
if not status then
    vim.notify("没有找到 lspconfig" )
    return
end

-- lua language server
nvimLsp.lua_ls.setup {
  on_init = function(client)
    print("into lua on_init")
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
    print("on init end")
  end,
  settings = {
    Lua = {
        diagnostics = {
            globals = { 'vim' },
        }
    }
  },
  on_attach = function(cli, bufnr)
    SetLSPKeyMap(bufnr)
    -- vim.notify("lua on_attach success.")
    -- print("lua on_attach success.")
  end,
  capabilities = Capabilities,
}

-- golang language server
nvimLsp.gopls.setup{}

-- print("run this")
