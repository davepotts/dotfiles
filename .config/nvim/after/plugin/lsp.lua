local lsp = require('lsp-zero').preset({
	name = 'minimal',
	set_lsp_keymaps = true,
	manage_nvim_cmp = true,
	suggest_lsp_servers = true,
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

lsp.setup()
