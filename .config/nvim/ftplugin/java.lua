local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
	vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
	return
end

local root_dir = require("davepotts.utils").java.find_root()
if root_dir == "" or root_dir == nil then
	return
end

local jdtls_path = vim.fn.stdpath('data') .. "/mason/packages/jdtls/"
local java_debug_path =
"/opt/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.44.0.jar"
local path_to_lsp_server = jdtls_path .. "config_linux"
local path_to_plugins = jdtls_path .. "plugins/"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
local lombok_path = jdtls_path .. "lombok.jar"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
os.execute("mkdir " .. workspace_dir)

local on_attach = function(client, bufnr)
	require 'jdtls.setup'.add_commands()
	require 'jdtls'.setup_dap({ hotcodereplace = 'auto' })
	require 'lsp-status'.register_progress()
	local cmp = require 'cmp'
	cmp.setup {
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "spell" },
			{ name = "tags" },
			{ name = "treesitter" },
			{ name = "calc" },
			{ name = "buffer" },
		})
	}

	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references() && vim.cmd("copen")<CR>', opts)
	buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	buf_set_keymap("n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
	buf_set_keymap("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
	buf_set_keymap("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
	buf_set_keymap("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
	buf_set_keymap("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
	buf_set_keymap("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
	buf_set_keymap("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	vim.api.nvim_exec([[
          hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
          hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
          augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
      ]], false)
end

local function get_capabilities()
	local default
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		default = cmp_nvim_lsp.default_capabilities()
	else
		default = vim.lsp.protocol.make_client_capabilities()
		default.textDocument.completion.completionItem.snippetSupport = true
		default.textDocument.completion.completionItem.resolveSupport = {
			properties = {
				"documentation",
				"detail",
				"additionalTextEdits",
			},
		}
	end

	local extended = jdtls.extendedClientCapabilities
	extended.resolveAdditonalTextEditsSupport = true

	return { default = default, extended = extended }
end

local bundles = { java_debug_path }

local config = {
	cmd = {
		'/usr/lib/jvm/java-17-openjdk-amd64/bin/java',
		'-agentlib:' .. 'jdwp=transport=dt_socket,server=y,suspend=n,address=1044',
		'-javaagent:' .. lombok_path,
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		"-Xms1g",
		"-Xmx2G",
		'-jar', path_to_jar,
		'-configuration', path_to_lsp_server,
		'-data', workspace_dir,
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
	},
	root_dir = root_dir,
	flags = { allow_incremental_sync = true },
	capabilities = get_capabilities().default,
	on_attach = on_attach,
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = get_capabilities().extended
	},
	settings = {
		java = {
			home = '/usr/lib/jvm/java-17-openjdk-amd64/',
			eclipse = { downloadSources = true },
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk-amd64/",
					}
				}
			},
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = { enabled = true },
			signatureHelp = { enabled = true },
			import = {
				maven = { enabled = true },
				exclusions = {
					"**/node_modules/**",
					"**/.metadata/**",
					"**/archetype-resources/**",
					"**/META-INF/maven/**",
					"/**/test/**"
				}
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org"
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				useBlocks = true,
			},
		},
	},
}

local finders = require 'telescope.finders'
local sorters = require 'telescope.sorters'
local actions = require 'telescope.actions'
local pickers = require 'telescope.pickers'
require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
	local opts = {}
	pickers.new(opts, {
		prompt_title    = prompt,
		finder          = finders.new_table {
			results = items,
			entry_maker = function(entry)
				return {
					value = entry,
					display = label_fn(entry),
					ordinal = label_fn(entry),
				}
			end,
		},
		sorter          = sorters.get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr)
			actions.goto_file_selection_edit:replace(function()
				local selection = actions.get_selected_entry(prompt_bufnr)
				actions.close(prompt_bufnr)
				cb(selection.value)
			end)

			return true
		end,
	}):find()
end

require('jdtls').start_or_attach(config)
