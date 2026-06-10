local M = {}

local Utils = require("koda.utils")

---@type koda.HighlightsFn
function M.get_hl(c)
  -- stylua: ignore
  return {
    GitSignsAdd           = { fg = c.success },
    GitSignsChange        = { fg = c.warning },
    GitSignsDelete        = { fg = c.danger },
    GitSignsDeleteInline  = { link = "DiffChange" },
    GitSignsAddInline     = { link = "DiffChange" },
    GitSignsChangeInLine  = { link = "DiffChange" },
    GitSignsCurrentLineBlame = { fg = Utils.blend(c.fg, c.line, 0.4) },
  }
end

return M
