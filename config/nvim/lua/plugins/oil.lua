local Plugin = {"stevearc/oil.nvim"}

Plugin.dependencies = {"nvim-tree/nvim-web-devicons"}

function Plugin.init()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory"})
end

function Plugin.config()
  require("oil").setup({
    view_options = {
      show_hidden = true
    }
  }
)
end

return Plugin
