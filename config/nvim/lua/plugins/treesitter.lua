-- Creates a syntax tree to be able to navigate code and configuration files better
local Plugin = {'nvim-treesitter/nvim-treesitter'}
Plugin.pin = true

Plugin.dependencies = {
  {'nvim-treesitter/nvim-treesitter-textobjects', pin = true},
}

Plugin.opts = {
  highlight = {
    enable = true,
  },
  -- Can also be a list of what you want to support
  ensure_installed = {"go", "javascript", "typescript", "markdown", "python", "lua"},
  -- Install parsers synchronously and is applied after 'ensure_installed'
  sync_install = false,

  indent = {
      enable = true
  },
}

function Plugin.build()
  pcall(vim.cmd, 'TSUpdate')
end

function Plugin.config(_, opts)
  require('nvim-treesitter.configs').setup(opts)
end

return Plugin
