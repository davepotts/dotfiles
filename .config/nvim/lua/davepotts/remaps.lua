local remap = require("davepotts.utils").remap

vim.g.mapleader = ","

remap("n", "<leader>v", "<C-w>v")
remap("n", "<C-h>", "<C-w>h")
remap("n", "<C-j>", "<C-w>j")
remap("n", "<C-k>", "<C-w>k")
remap("n", "<C-l>", "<C-w>l")

remap("n", "<A-j>", ":resize -2<CR>")
remap("n", "<A-k>", ":resize +2<CR>")
remap("n", "<A-h>", "<cmd> vertical resize -2<CR>")
remap("n", "<A-l>", ":vertical resize +2<CR>")

remap("n", "<TAB>", ":bn<CR>")
remap("n", "<S-TAB>", ":bp<CR>")
remap("n", "<leader>bd", ":bp<bar>sp<bar>bn<bar>bd<CR>")

remap("v", "J", ":m '>+1<CR>gv=gv")
remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "<", "<gv")
remap("v", ">", ">gv")

remap("n", "j", "gj")
remap("n", "k", "gk")
remap("n", "J", "mzJ`z")
remap("n", "<C-d>", "<C-d>zz")
remap("n", "<C-u>", "<C-u>zz")
remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")
