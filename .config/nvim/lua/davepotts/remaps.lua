remap = require("davepotts.utils").remap

vim.g.mapleader = ","

remap("n", "<leader>fv", vim.cmd.Ex)

remap("n", "<leader>vb", "<C-w>v")
remap("n", "<leader>hb", "<C-w>s")
remap("n", "<C-h>", "<C-w>h")
remap("n", "<C-j>", "<C-w>j")
remap("n", "<C-k>", "<C-w>k")
remap("n", "<C-l>", "<C-w>l")

remap("n", "<A-J>", ":resize -2<CR>")
remap("n", "<A-K>", ":resize +2<CR>")
remap("n", "<leader>hh", "<cmd> vertical resize -2<CR>")
remap("n", "<A-L>", ":vertical resize +2<CR>")

remap("n", "<TAB>", ":bn<CR>")
remap("n", "<S-TAB>", ":bp<CR>")
remap("n", "<leader>bd", ":bd<CR>")

remap("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
remap("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>")
remap("n", "<leader>fe", "<cmd> Telescope file_browser <CR>")
remap("n", "<leader>fw", "<cmd> Telescope live_grep <CR>")
remap("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
remap("n", "<leader>fh", "<cmd> Telescope help_tags <CR>")
remap("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
remap("n", "<leader>fc", "<cmd> Telescope colorschemes <CR>")

remap("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>")
remap("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<CR>")
remap("n", "K", ":lua vim.lsp.buf.hover()<CR>")
remap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>")
remap("n", "<leader>gr", ":lua vim.lsp.buf.references()<CR>")

remap("v", "J", ":m '>+1<CR>gv=gv")
remap("v", "K", ":m '<-2<CR>gv=gv")
remap("v", "<", "<gv")
remap("v", ">", ">gv")

remap("n", "J", "mzJ`z")
remap("n", "<C-d>", "<C-d>zz")
remap("n", "<C-u>", "<C-u>zz")
remap("n", "n", "nzzzv")
remap("n", "N", "Nzzzv")
