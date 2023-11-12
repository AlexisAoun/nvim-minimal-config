-- space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- install package manager if not installed
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
	}	
})

