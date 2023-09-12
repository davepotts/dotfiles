local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	'kyazdani42/nvim-web-devicons',
	{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.1',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	'nvim-lualine/lualine.nvim',
	"ray-x/starry.nvim",
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'hrsh7th/nvim-cmp' },
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'hrsh7th/cmp-buffer' },
			{ 'hrsh7th/cmp-path' },
			{ 'saadparwaiz1/cmp_luasnip' },
			{ 'hrsh7th/cmp-nvim-lua' },
			{ 'L3MON4D3/LuaSnip' },
			{ 'rafamadriz/friendly-snippets' },
		},
	},
	'mfussenegger/nvim-jdtls',
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"rcarriga/cmp-dap",
			"theHamsta/nvim-dap-virtual-text"
		}
	},
	'norcalli/nvim-colorizer.lua',
	{
		"okuuva/auto-save.nvim",
		init = function()
			require("auto-save").setup({
				debounce_delay = 5000,
			})
		end
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}

require("lazy").setup(plugins)
