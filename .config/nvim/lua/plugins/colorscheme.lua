return {
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  { "dracula/vim" },
  { "LazyVim/LazyVim", opts = { colorscheme = "dracula" } },
}
