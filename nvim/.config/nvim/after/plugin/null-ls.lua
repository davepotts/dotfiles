local status, null_ls = pcall(require, "null-ls")
if not status then
	print("null-ls is not installed")
	return
end
local formatting = null_ls.builtins.formatting
local sources = {
	formatting.prettierd,
	formatting.stylua,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = sources,

	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})
