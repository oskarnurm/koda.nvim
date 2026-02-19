local M = {}

---@param opts koda.Config|nil
function M.setup(opts)
  require("koda.config").setup(opts)

  -- Reload the colorscheme with :KodaFetch
  vim.api.nvim_create_user_command("KodaFetch", function()
    require("koda.utils").reload()
  end, {})
end

--- Get the current palette with any user overrides applied
---@return koda.Palette
function M.get_palette()
  local config = require("koda.config")
  local palette = require("koda.palette." .. vim.o.background)

  -- Apply custom color overrides if they exist
  if config.options.colors and type(config.options.colors) == "table" then
    palette = vim.tbl_deep_extend("force", palette, config.options.colors)
  end

  return palette
end

--- Blends two colors based on alpha transparency
---@param foreground string Foreground hex color
---@param background string Background hex color
---@param alpha number Blend factor (0 to 1)
---@return string # A hex color string like "#RRGGBB"
function M.blend(foreground, background, alpha)
  return require("koda.utils").blend(foreground, background, alpha)
end

--- Main function to apply the theme
function M.load()
  local config = require("koda.config")
  local groups = require("koda.groups") -- points to lua/koda/groups/init.lua
  local palette = M.get_palette()

  -- Reset existing highlights to prevent styles from previous themes from bleeding over.
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "koda"

  -- Unpack and resolve custom styles
  local hl_groups = groups.setup(palette, config.options)

  -- Apply highlights
  for group, hl in pairs(hl_groups) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return M
