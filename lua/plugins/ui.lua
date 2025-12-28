return {
  -- colorscheme
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    commit = "47f91c416daef12db467145e16bed5bbfe00add8",
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    'numToStr/Comment.nvim',
    commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
    opts = {
      opleader = { line = '<C-_>' }
    },
  },

  {
   'folke/which-key.nvim',
   commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
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
    commit = "5813e4878748805f1518cee7abb50fd7205a3a48",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    commit = "c2a0dd0d931d0fb07665e1fedb1ea688da3b80b4",
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },


  {'akinsho/bufferline.nvim', tag="v4.9.1", opts = {}}
}
