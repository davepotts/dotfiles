local remap = function(mode, lhs, rhs)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

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

remap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
remap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
remap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
remap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
remap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
remap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
remap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
remap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
remap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
remap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
remap('n', 'gr', '<cmd>lua vim.lsp.buf.references() && vim.cmd("copen")<CR>')
remap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
remap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
remap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
remap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
remap("n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>")
remap("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>")
remap("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>")
remap("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
remap("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>")
remap("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")
remap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
