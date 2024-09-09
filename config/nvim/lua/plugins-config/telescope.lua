local status, tele = pcall(require, "telescope")
if not status then
	vim.notify("没有找到 telescope")
	return
end

-- copy from telescope.builtin.__files.lua
-- 修改部分逻辑, 目的是为了优先使用 fd/fdfind
local function FindCommand()
  if 1 == vim.fn.executable "fd" then
    return { "fd", "--type", "f", "--color", "never" }
  elseif 1 == vim.fn.executable "fdfind" then
    return { "fdfind", "--type", "f", "--color", "never" }
  elseif 1 == vim.fn.executable "rg" then
    return { "rg", "--files", "--color", "never" }
  elseif 1 == vim.fn.executable "find" and vim.fn.has "win32" == 0 then
    return { "find", ".", "-type", "f" }
  elseif 1 == vim.fn.executable "where" then
    return { "where", "/r", ".", "*" }
  end
  return nil
end

local find_command = FindCommand()
if not find_command then
  vim.notify("builtin.find_files", {
    msg = "You need to install either find, fd, or rg",
    level = "ERROR",
  })
  return
else
  vim.notify(string.format("find_files use [%s]", table.concat(find_command, " ")))
end

tele.setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    }
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    find_files = {
      find_command = find_command,
    }
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

tele.load_extension('fzf')
tele.load_extension('file_browser')
