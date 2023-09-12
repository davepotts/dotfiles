local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
	vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
	return
end


function find_parent_root(markers, bufname)
  bufname = bufname or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local current_dir = vim.fn.fnamemodify(bufname, ':p:h')
	local root_dir
  local getparent = function(_dirname)

    return vim.fn.fnamemodify(_dirname, ':h')
  end
  while getparent(current_dir) ~= "/" do
    for _, marker in ipairs(markers) do
      if vim.loop.fs_stat(require("jdtls.path").join(current_dir, marker)) then
        root_dir = current_dir
      end
    end
    current_dir = getparent(current_dir)
  end
	return root_dir
end

local root_dir = find_parent_root({ ".git", "pom.xml", "mvnw" })

if root_dir == "" or root_dir == nil then
	return
end

local jdtls_path = vim.fn.stdpath('data') .. "/mason/packages/jdtls/"
local java_debug_path = "/opt/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.44.0.jar"
local path_to_lsp_server = jdtls_path .. "config_linux"
local path_to_plugins = jdtls_path .. "plugins/"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.500.v20230622-2056.jar"
local lombok_path = jdtls_path .. "lombok.jar"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name

os.execute("mkdir -p " .. workspace_dir)

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

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		"-Xms1g",
		"-Xmx2G",
		'-javaagent:' .. lombok_path,
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', path_to_jar,
		'-configuration', path_to_lsp_server,
		'-data', workspace_dir,
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
			maven = { downloadSources = true, updateSnapshots = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = {
				settings = {
					url = "/home/dave/dotfiles/Lhasa.xml"
				},
				enabled = true
			},
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

local remap = require("davepotts.utils").remap
remap("n", "<leader>dc", "<Cmd>lua require'jdtls'.test_class()<CR>")
remap("n", "<leader>dm", "<Cmd>lua require'jdtls'.test_nearest_rmethod()<CR>")
remap("v", "<leader>cv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
remap("n", "<leader>cv", "<Cmd>lua require('jdtls').extract_variable()<CR>")
remap("v", "<leader>cm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")

local java_format_on_save = vim.api.nvim_create_augroup("java_format_on_save", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = java_format_on_save,
	buffer = 0,
	callback = function()
		vim.lsp.buf.format()
		require("jdtls").organize_imports()
	end
})
