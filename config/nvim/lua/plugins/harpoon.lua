local Plugin = {"ThePrimeagen/harpoon"}

function Plugin.config()
  local mark = require("harpoon.mark")
  local ui = require("harpoon.ui")

  vim.keymap.set("n", "<leader>ha", mark.add_file)
  vim.keymap.set("n", "<leader>he", ui.toggle_quick_menu)
  vim.keymap.set("n", "<leader>hn", function() ui.nav_next() end)
  vim.keymap.set("n", "<leader>hp", function() ui.nav_prev() end)
end

return Plugin
