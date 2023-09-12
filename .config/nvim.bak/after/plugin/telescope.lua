require('telescope').setup {
	defaults = {
		file_ignore_patterns = {
			"node_modules",
			".idea",
		}
	}
}


local remap = require("davepotts.utils").remap
remap("n", "<leader>ff", "<cmd> Telescope find_files <CR>")
remap("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>")
remap("n", "<leader>fe", "<cmd> Ex <CR>")
remap("n", "<leader>fg", "<cmd> Telescope live_grep <CR>")
remap("n", "<leader>fb", "<cmd> Telescope buffers <CR>")
remap("n", "<leader>fh", "<cmd> Telescope help_tags <CR>")
remap("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>")
remap("n", "<leader>fc", "<cmd> Telescope colorschemes <CR>")
