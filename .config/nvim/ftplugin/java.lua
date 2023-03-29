local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
	vim.notify "JDTLS not found, install with `:LspInstall jdtls`"
	return
end

local function find_root()
	local markers = { "mvnw", "pom.xml" }
	local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local dirname = vim.fn.fnamemodify(bufname, ":p:h")
	local root = vim.fn.getcwd()
	local match = nil
	local getparent = function(p)
		return vim.fn.fnamemodify(p, ':h')
	end
	while getparent(dirname) ~= dirname or dirname == root do
		for _, marker in ipairs(markers) do
			if vim.loop.fs_stat(require("jdtls.path").join(dirname, marker)) then
				match = dirname
			end
		end
		dirname = getparent(dirname)
	end
	return match
end

local function common_capabilities()
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		return cmp_nvim_lsp.default_capabilities()
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	return capabilities
end

local capabilities = common_capabilities()
local jdtls_path = vim.fn.stdpath('data') .. "/mason/packages/jdtls"
local path_to_lsp_server = jdtls_path .. "/config_linux"
local path_to_plugins = jdtls_path .. "/plugins/"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
local lombok_path = jdtls_path .. "lombok.jar"

local root_dir = find_root()

print("root_dir: " .. (root_dir or "nil"))
if root_dir == "" or root_dir == nil then
	return
end
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/site/java/workspace-root/' .. project_name
os.execute("mkdir " .. workspace_dir)

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditonalTextEditsSupport = true

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
		"\n"
	)
)

-- Main Config
local config = {
	cmd = {
		'/usr/lib/jvm/java-17-openjdk-amd64/bin/java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-javaagent:' .. lombok_path,
		"-Xms1g",
		"-Xmx2G",
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', path_to_jar,
		'-configuration', path_to_lsp_server,
		'-data', workspace_dir,
	},
	capabilities = capabilities,
	root_dir = root_dir,
	flags = { allow_incremental_sync = true },
	init_options = { bundles = bundles },
	settings = {
		java = {
			home = '/usr/lib/jvm/java-17-openjdk-amd64/',
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk-amd64/",
					}
				}
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = true,
			},
			import = {
				maven = {
					enabled = true
				},
				exclusions = {
					"**/node_modules/**",
					"**/.metadata/**",
					"**/archetype-resources/**",
					"**/META-INF/maven/**",
					"/**/test/**"
				}
			},
			signatureHelp = { enabled = true },
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
			contentProvider = { preferred = "fernflower" },
			extendedClientCapabilities = extendedClientCapabilities,
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

require('jdtls').start_or_attach(config)
