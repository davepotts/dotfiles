local status, lualine = pcall(require, "lualine")
if not status then
	print("LuaLine is not installed")
	return
end

lualine.setup({
	options = {
		theme ="tokyonight",
  }
})
