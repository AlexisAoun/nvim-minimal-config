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
	{
	    'AlexvZyl/nordic.nvim',
	    commit = 'be1bab59c56668af7020af11190ec7fcd25d59b4',
	    lazy = false,
	    priority = 1000,
	    config = function()
		local colors = require('nordic.colors')
		require 'nordic'.setup {
			override = {
				Visual = {
					bg = colors.gray2
				}
			}
		}
	        require 'nordic'.load()
	    end
	},
  	{
  	  -- Set lualine as statusline
  	  'nvim-lualine/lualine.nvim',
  	  -- See `:help lualine.txt`
	  commit = "2248ef254d0a1488a72041cfb45ca9caada6d994",
  	  opts = {
  	    options = {
  	      icons_enabled = false,
  	      theme = 'nordic',
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

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
