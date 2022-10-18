vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }           -- use system clipboard
vim.opt.mouse=""                                                -- disables mouse input

vim.opt.number=true                                             -- show line numbers
vim.opt.relativenumber=true                                     -- use relative line numbering

vim.opt.hlsearch=true                                           -- Highlight all search pattern matches
vim.opt.incsearch=true                                          -- Highlight all matching instances of a search in the buffer

vim.opt.expandtab=true                                          -- convert tab character to space characters
vim.opt.tabstop=2                                               -- Number of spaces that a tab char (\t) adds
vim.opt.shiftwidth=2                                            -- Number of spaces added or removed when indenting a line 
vim.opt.softtabstop=2                                           -- Number of spaces a tab keypress adds
vim.opt.smartindent=true                                        -- smart autoindenting when starting a new line
vim.opt.wrap = true                                             -- wrap lines that extend past the right of the screen
vim.opt.linebreak = true                                        -- ensures that wrapped lines do not break within a word
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.cmdheight = 1
vim.opt.updatetime = 50
vim.opt.shortmess:append("c")
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 20
