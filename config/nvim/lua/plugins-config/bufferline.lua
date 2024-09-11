-- bufferline 配置

local status, bufferline = pcall(require, "bufferline")
if not status then
    DebugNotify("没有找到 bufferline")
  return
end

bufferline.setup({
    options = {
		close_command = "bdelete! %d",       -- 点击关闭按钮关闭
		right_mouse_command = "bdelete! %d", -- 右键点击关闭
		indicator = {
			icon = '▎', -- 分割线
			style = 'underline',
		},
		buffer_close_icon = '󰅖',
		modified_icon = '●',
		close_icon = '',
		offsets = {
			{
				filetype = "NvimTree",
				text = "File Explorer" ,
				text_align = "left",
				separator = true,
			}
		},
    },
})


