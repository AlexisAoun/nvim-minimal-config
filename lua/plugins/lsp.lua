return {
  -- NOTE: This is where your plugins related to LSP can be installed.
  -- The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    commit = "d696e36d5792daf828f8c8e8d4b9aa90c1a10c2a",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        'mason-org/mason.nvim',
        commit = "57e5a8addb8c71fb063ee4acda466c7cf6ad2800",
        opts = {}
      },
      { 'mason-org/mason-lspconfig.nvim', commit = "9f9c67795d0795a6e8612f5a899ca64a074a1076" },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {'saghen/blink.cmp', commit = "b19413d214068f316c78978b08264ed1c41830ec"},
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    commit = "d97d85e01339f01b842e6ec1502f639b080cb0fc",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        commit = "3732756842a2f7e0e76a7b0487e9692072857277",
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
      { 'saadparwaiz1/cmp_luasnip',     commit = "98d9cb5c2c38532bd9bdb481067b20fea8f32e90" },

      -- Adds LSP completion capabilities

      { 'hrsh7th/cmp-nvim-lsp',         commit = "cbc7b02bb99fae35cb42f514762b89b5126651ef" },
      { 'hrsh7th/cmp-path',             commit = "c642487086dbd9a93160e1679a1327be111cbc25" },

      -- Adds a number of user-friendly snippets
      { 'rafamadriz/friendly-snippets', commit = "572f5660cf05f8cd8834e096d7b4c921ba18e175" },
    },

    config = function ()
	local cmp = require 'cmp'
	local luasnip = require 'luasnip'
	require('luasnip.loaders.from_vscode').lazy_load()
	luasnip.config.setup {}
	cmp.setup {
	  snippet = {
	    expand = function(args)
	      luasnip.lsp_expand(args.body)
	    end,
	  },
	  completion = {
	    completeopt = 'menu,menuone,noinsert',
	  },
	  mapping = cmp.mapping.preset.insert {
	    ['<C-n>'] = cmp.mapping.select_next_item(),
	    ['<C-p>'] = cmp.mapping.select_prev_item(),
	    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
	    ['<C-f>'] = cmp.mapping.scroll_docs(4),
	    ['<C-Space>'] = cmp.mapping.complete {},
	    ['<CR>'] = cmp.mapping.confirm {
	      behavior = cmp.ConfirmBehavior.Replace,
	      select = true,
	    },
	    ['<Tab>'] = cmp.mapping(function(fallback)
	      if cmp.visible() then
	        cmp.select_next_item()
	      elseif luasnip.expand_or_locally_jumpable() then
	        luasnip.expand_or_jump()
	      else
	        fallback()
	      end
	    end, { 'i', 's' }),
	    ['<S-Tab>'] = cmp.mapping(function(fallback)
	      if cmp.visible() then
	        cmp.select_prev_item()
	      elseif luasnip.locally_jumpable(-1) then
	        luasnip.jump(-1)
	      else
	        fallback()
	      end
	    end, { 'i', 's' }),
	  },
	  sources = {
	    { name = 'nvim_lsp' },
	    { name = 'luasnip' },
	    { name = 'path' },
	  },
	}
    end
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    commit = "6e42d823ce0a5a76180c473c119c7677738a09d1",
    build = ':TSUpdate',
    config = function ()
	require'nvim-treesitter'.install { 'rust', 'javascript', 'typscript', 'c', 'cpp', 'lua', 'bash', 'go', 'python', 'java', 'html', 'css' }
    end
  },

}
