local Plugin = { "epwalsh/obsidian.nvim" }

Plugin.dependencies = {
  { "nvim-lua/plenary.nvim" }
}

--Plugin.lazy = true

--Plugin.ft = "markdown"

Plugin.opts = {
  workspaces = {
    {
      name = "imperial",
      path = "~/Documents/ImperialHound",
    },
  },

  notes_subdir = "to-organize",

  log_level = vim.log.levels.INFO,

  daily_notes = {
    folder = "1. Daily",
    date_format = "%Y-%m-%d",
    template = "Daily"
  },

  -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    -- Trigger completion at 2 chars.
    min_chars = 2,
  },

  new_notes_location = "notes_subdir",

  templates = {
    folder = "Settings/Template"
  },

  -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
  -- URL it will be ignored but you can customize this behavior here.
  ---@param url string
  follow_url_func = function(url)
    -- Open the URL in the default web browser.
    vim.fn.jobstart({ "open", url }) -- Mac OS
    -- vim.fn.jobstart({"xdg-open", url})  -- linux
    -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    -- vim.ui.open(url) -- need Neovim 0.10.0+
  end,

  -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
  -- file it will be ignored but you can customize this behavior here.
  ---@param img string
  follow_img_func = function(img)
    vim.fn.jobstart { "qlmanage", "-p", img } -- Mac OS quick look preview
    -- vim.fn.jobstart({"xdg-open", url})  -- linux
    -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
  end,

  attachments = {
    img_folder = "Settings/Attachment"
  },

  -- Optional, customize how note IDs are generated given an optional title.
  ---@param title string|?
  ---@return string
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
    local suffix = ""
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,

  -- Optional, customize how note file names are generated given the ID, target directory, and title.
  ---@param spec { id: string, dir: obsidian.Path, title: string|? }
  ---@return string|obsidian.Path The full path to the new note.
  note_path_func = function(spec)
    -- This is equivalent to the default behavior.
    local path = spec.dir / tostring(spec.id)
    return path:with_suffix(".md")
  end,

  -- Optional, customize how wiki links are formatted. You can set this to one of:
  --  * "use_alias_only", e.g. '[[Foo Bar]]'
  --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
  --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
  --  * "use_path_only", e.g. '[[foo-bar.md]]'
  -- Or you can set it to a function that takes a table of options and returns a string, like this:
  wiki_link_func = function(opts)
    return require("obsidian.util").wiki_link_id_prefix(opts)
  end,

  -- Optional, customize how markdown links are formatted.
  markdown_link_func = function(opts)
    return require("obsidian.util").markdown_link(opts)
  end,

  -- Either 'wiki' or 'markdown'.
  preferred_link_style = "wiki",

  -- Optional, boolean or a function that takes a filename and returns a boolean.
  -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
  disable_frontmatter = true,

  -- Optional, alternatively you can customize the frontmatter data.
  ---@return table
  note_frontmatter_func = function(note)
    -- Add the title of the note as an alias.
    if note.title then
      note:add_alias(note.title)
    end

    local out = { id = note.id, aliases = note.aliases, tags = note.tags }

    -- `note.metadata` contains any manually added fields in the frontmatter.
    -- So here we just make sure those fields are kept in the frontmatter.
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end

    return out
  end,

  sort_by = "modified",
  sort_reversed = true,

  -- Set the maximum number of lines to read from notes on disk when performing certain searches.
  search_max_lines = 1000,
}

function Plugin.init()
  vim.keymap.set("n", "<leader>oo", ":ObsidianQuickSwitch <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>on", ":ObsidianNew <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>of", ":ObsidianFollowLink <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>od", ":ObsidianToday <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>oy", ":ObsidianYesterday <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>ot", ":ObsidianTomorrow <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>o`", ":ObsidianTemplate <CR>",
    { silent = true, noremap = true }
  )

  vim.keymap.set("n", "<leader>oc", ":ObsidianToggleCheckbox <CR>",
    { silent = true, noremap = true }
  )
end

return Plugin
