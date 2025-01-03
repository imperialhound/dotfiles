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

  bind('n', '<leader>fgs', '<cmd>Telescoe git_status<cr>')

  -- Telescope for LSP
  bind('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>')

  -- Telescope for TODOs
  bind('n', '<leader>ft', '<cmd>TodoTelescope<cr>')
end

function Plugin.config()
  local command = vim.api.nvim_create_user_command

  local telescope = require('telescope')
  local actions = require('telescope.actions')
  require('todo-comments').setup({})

  command('TGrep', function(input)
    require('telescope.builtin').grep_string({ search = input.args })
  end, { nargs = 1 })

  local function defaults(title)
    return {
      prompt_title = title,
      results_title = false
    }
  end

  local function dropdown(title, previewer)
    return {
      prompt_title = title,
      previewer = previewer or true,
      theme = 'dropdown'
    }
  end

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

      -- Default layout options
      prompt_prefix = ' ',
      selection_caret = '❯ ',
      layout_strategy = 'vertical',
      sorting_strategy = 'ascending',
      layout_config = {
        preview_cutoff = 25,
        mirror = true,
        prompt_position = 'top'
      },
    },
    pickers = {
      buffers = defaults(),
      find_files = defaults('Find Files'),
      oldfiles = dropdown('History'),
      keymaps = dropdown(),
      command_history = dropdown(),
      colorscheme = dropdown(),
      git_commits = defaults('Git Commits'),
      grep_string = defaults('Search'),
      treesitter = defaults('Buffer Symbols'),
      current_buffer_fuzzy_find = defaults('Lines'),
      live_grep = defaults('Grep'),

      commands = defaults(),
      help_tags = defaults(),
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

function user.job_output(cid, data, name)
  for i, val in pairs(data) do
    print(val)
  end
end

function user.build_fzy()
  if vim.fn.executable('make') == 0 then
    return
  end

  local workdir = vim.api.nvim_get_runtime_file('deps/fzy-lua-native', 1)

  if workdir[1] == nil then
    return
  end

  vim.fn.jobstart({ 'make' }, {
    cwd = workdir[1],
    on_stdout = user.job_output,
  })
end

return Plugin
