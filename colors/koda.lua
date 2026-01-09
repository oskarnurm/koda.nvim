-- colors/koda.lua
local config = require("koda.config")
local groups = require("koda.groups") -- Points to lua/koda/groups/init.lua
local palette = require("koda.palette." .. vim.o.background)

-- Takes the user's 'colors' table from setup() and forces it into the palette
if config.options.colors and type(config.options.colors) == "table" then
  palette = vim.tbl_deep_extend("force", palette, config.options.colors)
end

-- Clear existing highlights
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "koda"

-- Apply highlights
local hl_groups = groups.setup(palette, config.options)

for group, hl in pairs(hl_groups) do
  -- If the group has a style, merge it into the highlight properties
  if hl.style and type(hl.style) == "table" then
    hl = vim.tbl_extend("force", hl, hl.style)
    hl.style = nil -- remove the custom 'style' key so Neovim doesn't complain
  end

  vim.api.nvim_set_hl(0, group, hl)
end
