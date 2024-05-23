return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      root_dir = function(fname)
        return require("lspconfig").util.root_pattern("pom.xml", "gradle.build", ".git")(fname) or vim.fn.getcwd()
      end,
      jdtls = function(opts)
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        local jvmArg = "-javaagent:" .. install_path .. "/lombok.jar"
        table.insert(opts.cmd, "--jvm-arg=" .. jvmArg)
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
