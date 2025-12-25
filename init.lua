-- this config is an adaptation of kickstart, https://github.com/nvim-lua/kickstart.nvim/
-- dependencies : ripgrep (for telescope), wl-clipboard, treesitter-cli

-- space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy-plugins')

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])
vim.o.swapfile = false

--some settings
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

vim.wo.wrap = false

vim.keymap.set('n', '<leader>e', ':20 Lexplore<CR>', { desc = 'File [E]xplorer' })

vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true, desc = 'Open diagnostic float'})

vim.keymap.set('n', '<S-l>', ":bnext<CR>")
vim.keymap.set('n', '<S-h>', ":bprevious<CR>")
vim.keymap.set('n', '<S-q>', ":bdelete<CR>")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
