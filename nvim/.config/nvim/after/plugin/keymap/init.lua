local Remap = require("davepotts.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

-- toggle NetRW
vim.api.nvim_set_keymap('n', '<Leader>b', ':Lexplore<CR>', { noremap = true, silent = true })

--Telescope
local builtin = require('telescope.builtin')
nnoremap('ff', builtin.find_files, {})
nnoremap('fg', builtin.live_grep, {})
nnoremap('fb', builtin.buffers, {})
nnoremap('fh', builtin.help_tags, {})



-- move visually selected lines up and down in the file
vnoremap("K", ":m '<-2<CR>gv=gv")
vnoremap("J", ":m '>+1<CR>gv=gv")
