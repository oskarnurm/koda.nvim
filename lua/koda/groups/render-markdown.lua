local Utils = require("koda.utils")

local M = {}

---@type koda.HighlightsFn
function M.get_hl(c)
  local h1 = Utils.blend(c.fg, c.bg, 0.1)
  -- stylua: ignore
  return {
    RenderMarkdownCode = { bg = c.line },
    RenderMarkdownH1Bg = { bg = h1 },
    RenderMarkdownH2Bg = { bg = h1 },
    RenderMarkdownH3Bg = { bg = h1 },
    RenderMarkdownH4Bg = { bg = h1 },
    RenderMarkdownH5Bg = { bg = h1 },
    RenderMarkdownH6Bg = { bg = h1 },
  }
end

return M
