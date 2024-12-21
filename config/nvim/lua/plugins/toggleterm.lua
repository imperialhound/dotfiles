-- Handle terminal windows
local Plugin = {'akinsho/toggleterm.nvim'}
local open_mapping = '<M-i>'

Plugin.cmd = {'Term', 'ToggleTerm', 'TermExec'}

function Plugin.init()
  vim.keymap.set({'n', 'i', 'x'}, open_mapping, '<cmd>Term<cr>', {desc = 'Toggle terminal'})
  vim.keymap.set('t', open_mapping, '<cmd>ToggleTerm<cr>')

  vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<cr>')
  vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>')
  vim.keymap.set('t', '<leader>tt', '<cmd>ToggleTerm<cr><cmd>ToggleTerm direction=tab<cr>')
  vim.keymap.set('t', '<leader>tf', '<cmd>ToggleTerm<cr><cmd>ToggleTerm direction=float<cr>')
end

function Plugin.config()
  require('toggleterm').setup({})
end

return Plugin
