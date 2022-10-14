
local status, treesitter = pcall(require, 'nvim-treesitter.configs')

if(not status) then
  print("treesitter not installed")
  return
end

treesitter.setup({
  ensure_installed = {'javascript', 'typescript', 'css', 'html', 'markdown',"json","kotlin","scss","yaml"},
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
})
