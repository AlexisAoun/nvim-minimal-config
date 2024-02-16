-- space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--install package manager if not installed
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', 
    lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

	-- colorscheme
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
  	{
  	  -- Set lualine as statusline
  	  'nvim-lualine/lualine.nvim',
  	  -- See `:help lualine.txt`
	  commit = "2248ef254d0a1488a72041cfb45ca9caada6d994",
  	  opts = {
  	    options = {
  	      icons_enabled = false,
  	      theme = 'gruvbox',
  	      component_separators = '|',
  	      section_separators = '',
  	    },
  	  },
  	},
	{ 'numToStr/Comment.nvim', opts = {} },
	{ 'folke/which-key.nvim', 
	  event = "VeryLazy",
  	  init = function()
  	  	vim.o.timeout = true
  	  	vim.o.timeoutlen = 300
  	  end,
	  opts = {}
	},
	{
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

})

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

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
vim.wo.relativenumber=true
