local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
})

lsp.set_server_config({
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = true }
		}
	}
})

lsp.format_on_save({
	format_opts = {
		timeout_ms = 10000 },
	servers = {
		['jdtls'] = { 'java' },
		['typescript-language-server'] = { 'typescript' },
		['lua_ls'] = { 'lua' },
	}
})
lsp.nvim_workspace()
lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = false,
	float = true,
})

local function on_language_status(_, result)
	if result.message == nil then
		return
	end
	local command = vim.api.nvim_command
	command 'echohl ModeMsg'
	command(string.format('echo "%s"', result.message))
	command 'echohl None'
end

require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				disable = { "lowercase-global" },
				globals = { "vim" }
			}
		}
	}
})

require("lspconfig").jdtls.setup({
	handlers = {
		["$/progress"] = vim.schedule_wrap(on_language_status),
	},
})
