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
	  commit = "7d131a8d3ba5016229e8a1d08bf8782acea98852",
  	  opts = {
  	    options = {
  	      icons_enabled = false,
  	      theme = 'gruvbox',
  	      component_separators = '|',
  	      section_separators = '',
  	    },
  	  },
  	},

	{ 'numToStr/Comment.nvim', 
	  commit = "0236521ea582747b58869cb72f70ccfa967d2e89",
	  opts = {},
  	},

	{ 'folke/which-key.nvim', 
	  commit="4433e5ec9a507e5097571ed55c02ea9658fb268a",
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
    commit="2c2463dbd82eddd7dbab881c3a62cfbfbe3c67ae",
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

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    commit="d1bab4cf4b69e49d6058028fd933d8ef5e74e680",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', 
      commit="c43eeb5614a09dc17c03a7fb49de2e05de203924", config = true },
      {'williamboman/mason-lspconfig.nvim', commit="fe4cce44dec93c69be17dad79b21de867dde118a"},
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    commit="04e0ca376d6abdbfc8b52180f8ea236cbfddf782",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        commit="f3b3d3446bcbfa62d638b1903ff00a78b2b730a1",
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      {'saadparwaiz1/cmp_luasnip', commit="05a9ab28b53f71d1aece421ef32fee2cb857a843"},

      -- Adds LSP completion capabilities

      {'hrsh7th/cmp-nvim-lsp', commit="5af77f54de1b16c34b23cba810150689a3a90312"},
      {'hrsh7th/cmp-path', commit="91ff86cd9c29299a64f968ebb45846c485725f23"},

      -- Adds a number of user-friendly snippets
      {'rafamadriz/friendly-snippets', commit="dbd45e9ba76d535e4cba88afa1b7aa43bb765336"},
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    commit="17d68ac13c902f55253b7facb47df4c0ae532575",
    dependencies = {
        {'nvim-treesitter/nvim-treesitter-textobjects', commit="7f00d94543f1fd37cab2afa2e9a6cd54e1c6b9ef"}
    },
    build = ':TSUpdate',
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

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
