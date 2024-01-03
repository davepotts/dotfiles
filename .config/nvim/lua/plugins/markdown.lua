return {
  "jxnblk/vim-mdx-js",
  {
    "instant-markdown/vim-instant-markdown",
    ft = { "markdown" },
    build = "npm install",
    config = function()
      vim.g.instant_markdown_autostart = 0
    end,
  },
}
