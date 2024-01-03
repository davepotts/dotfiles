local util = require("lspconfig.util")
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      angularls = function(_, opts)
        opts.root_dir = util.root_pattern("angular.json", "nx.json")
      end,
    },
  },
}
