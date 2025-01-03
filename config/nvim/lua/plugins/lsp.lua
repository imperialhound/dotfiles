local Plugin = { "neovim/nvim-lspconfig" }

Plugin.dependencies = {
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "j-hui/fidget.nvim" }, -- Neovim notifications and LSP progress messages
  {
    "folke/lazydev.nvim",  -- Properly configure LuaLs for editing Neovim configs
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "mfussenegger/nvim-lint" },
  { "rshkarin/mason-nvim-lint" },
  { "artemave/workspace-diagnostics.nvim" },
}

function Plugin.config()
  -- Create autocommand to automatically update imports of go files
  -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#imports-and-formatting
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = "*.go",
    callback = function()
      local params = vim.lsp.util.make_range_params()
      params.context = { only = { "source.organizeImports" } }
      -- buf_request_sync defaults to a 1000ms timeout. Depending on your
      -- machine and codebase, you may want longer. Add an additional
      -- argument after params if you find that you have to write the file
      -- twice for changes to be saved.
      -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
      for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
            vim.lsp.util.apply_workspace_edit(r.edit, enc)
          end
        end
      end
      vim.lsp.buf.format({ async = false })
    end
  })
  -- Create autocommand to set keybindings each time an LspAttach event occurs
  -- An lspAttach event is when a language server is attached to a buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
      local opts = {
        buffer = true,
        noremap = true
      }
      -- Jump to definition
      vim.keymap.set("n", "<leader>lg", vim.lsp.buf.definition, opts)
      -- List all implentations for the symbol under the cursor
      vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
      -- Jump to declaration
      vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration, opts)
      -- Displays a functions singature information
      vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)
      -- List all references
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)
      -- Rename all references to the symbol under the cursor
      vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)
      -- Displays hover information about the symbol under the cursor
      vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
      -- Selects a code action available at the current cursor in position
      vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, opts)
      -- Move to previous diagnostic
      vim.keymap.set("n", "<leader>ldp", vim.diagnostic.goto_prev, opts)
      -- Move to next diagnostic
      vim.keymap.set("n", "<leader>ldn", vim.diagnostic.goto_next, opts)
      -- Show diagnostics in a floating window
      vim.keymap.set("n", "<leader>ldf", vim.diagnostic.goto_prev, opts)
    end
  })
  -- Autocompletion and language server setup
  local cmp = require("cmp")
  local cmp_lsp = require("cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities())

  require("fidget").setup({})

  -- Mason is a NVIM package manager for setting up LSP servers, DAP servers, linters and formatters
  require("mason").setup()
  require("mason-lspconfig").setup({
    automatic_installation = true,
    ensure_installed = {
      "terraformls",
      "gopls", "golangci_lint_ls", "templ",
      "pyright",
      "yamlls",
      "lua_ls",
      "rust_analyzer",
      "tsserver",
      "clangd",
      "jqls",
      "jsonls",
      "helm_ls",
    },
    handlers = {
      function(server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
          end
        }
      end,
    }
  })

  vim.api.nvim_set_keymap('n', '<leader>x', '', {
    noremap = true,
    callback = function()
      for _, client in ipairs(vim.lsp.get_clients()) do
        require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
      end
    end
  })
  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    -- keybindings for seleting completions
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ['<Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if cmp.visible() then
          cmp.select_next_item(cmp_select)
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),
    }),
    -- Data sources nvim-cmp will use to populate the completion list
    sources = cmp.config.sources({
      { name = 'nvim_lsp' }, -- Suggestions from language server
      { name = 'luasnip' },  -- For luasnip users.
    }, {
      { name = 'buffer' },   -- Suggest words found in current buffer
    })
  })

  vim.diagnostic.config({
    -- update_in_insert = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  })

  require("mason-nvim-lint").setup({
    quiet_mode = true,
    ensure_installed = {
      "tflint",
      "eslint_d",
      "golangci-lint",
      "pylint",
    }
  })
end

return Plugin
