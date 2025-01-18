-- Fuzzy Finder
local Plugin = { 'nvim-telescope/telescope.nvim' }
local user = {}

Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-telescope/telescope-fzy-native.nvim',
    build = function() user.build_fzy() end
  },
  { "folke/todo-comments.nvim" }
}

Plugin.cmd = 'Telescope'

function Plugin.init()
  local bind = vim.keymap.set

  -- Search pattern
  bind('n', '<leader>fp', '<cmd>Telescope live_grep<cr>')

  -- Show key bindings list
  bind('n', '<leader>?', '<cmd>Telescope keymaps<cr>')

  -- Find files by name
  bind('n', '<leader>ff', '<cmd>Telescope find_files<cr>')

  -- Search symbols in buffer
  bind('n', '<leader>fs', '<cmd>Telescope treesitter<cr>')

  -- Search buffer lines
  bind('n', '<leader>fb', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

  -- Search in files history
  bind('n', '<leader>fh', '<cmd>Telescope oldfiles<cr>')

  -- Search in active buffers list
  bind('n', '<leader>bb', '<cmd>Telescope buffers<cr>')

  -- Telescope for Git
  bind('n', '<leader>fgc', '<cmd>Telescope git_commits<cr>')

  bind('n', '<leader>fgp', '<cmd>Telescope git_bcommits<cr>')

  bind('n', '<leader>fgb', '<cmd>Telescope git_branches<cr>')

  bind('n', '<leader>fgs', '<cmd>Telescope git_status<cr>')

  -- Telescope for LSP
  bind('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')

  -- Telescope for TODOs
  bind('n', '<leader>ft', '<cmd>TodoTelescope<cr>')

  -- Help
  bind('n', '<leader>fe', '<cmd>Telescope help_tags<cr>')
end

function Plugin.config()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  require('todo-comments').setup({})

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<esc>'] = actions.close,
          ['<M-k>'] = actions.move_selection_previous,
          ['<M-j>'] = actions.move_selection_next,
          ['<M-b>'] = actions.select_default,
        }
      },
    },
    extension = {
      fzy_native = {
        override_generic_sorter = true,
        override_file_sorter = true
      },
    }
  })

  telescope.load_extension('fzy_native')
end

return Plugin
