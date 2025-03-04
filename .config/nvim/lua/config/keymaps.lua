-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local remap = function(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

remap("v", "J", ":m '>+1<CR>gv=gv")
remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "<", "<gv")
remap("v", ">", ">gv")
remap("n", "<A-j>", ":resize -5<CR>")
remap("n", "<A-k>", ":resize +5<CR>")
remap("n", "<A-h>", "<cmd> vertical resize -5<CR>")
remap("n", "<A-l>", ":vertical resize +5<CR>")
remap("n", "p", "_dP")
remap("n", "P", "_dp")
remap("v", "p", "_dP")
remap("v", "P", "_dP")
