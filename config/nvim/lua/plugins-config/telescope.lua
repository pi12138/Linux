local status, tele = pcall(require, "telescope")
if not status then
	DebugNotify("没有找到 telescope")
	return
end

-- copy from telescope.builtin.__files.lua
-- 修改部分逻辑, 目的是为了优先使用 fd/fdfind
local function FindCommand()
  if 1 == vim.fn.executable "fd" then
    return { "fd", "--type", "f", "--color", "never", "--no-ignore" }
  elseif 1 == vim.fn.executable "fdfind" then
    return { "fdfind", "--type", "f", "--color", "never", "--no-ignore" }
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
  DebugNotify("builtin.find_files You need to install either find, fd, or rg")
  return
else
  DebugNotify(string.format("find_files use [%s]", table.concat(find_command, " ")))
end

local teleActions = require("telescope.actions")

tele.setup{
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
        ["<esc>"] = teleActions.close,
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
    fzf = {
      fuzzy = false,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

tele.load_extension('fzf')
tele.load_extension('file_browser')
tele.load_extension('live_grep_args')
