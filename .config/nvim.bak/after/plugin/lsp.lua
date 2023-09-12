local lsp = require("lsp-zero").preset({
	name = "minimal",
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
})

lsp.set_server_config({
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = true,
			},
		},
	},
})

lsp.format_on_save({
	format_opts = {
		timeout_ms = 10000,
	},
})

lsp.nvim_workspace()
lsp.on_attach(function()
	lsp.buffer_autoformat()
end)

lsp.skip_server_setup({ "jdtls" })
lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = true,
})

require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				disable = { "lowercase-global" },
				globals = { "vim" },
			},
		},
	},
})

local remap = require("davepotts.utils").remap
remap("n", "<leader><leader>", "<CMD>lua vim.lsp.buf.code_action()<CR>")
remap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
remap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
remap("n", "gr", '<cmd>lua vim.lsp.buf.references() && vim.cmd("copen")<CR>')
remap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
remap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
remap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
remap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
remap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
remap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
