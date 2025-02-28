return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = function(opts)
        opts["settings"] = {
          java = {
            format = { settings = { url = "/home/dave/dotfiles/Lhasa.xml" }, enabled = true },
          },
        }
        return opts
      end,
    },
  },
}
