-- lua/koda/groups/syntax.lua
local utils = require("koda.utils")

local M = {}

function M.get(c, opts)
    -- stylua: ignore
    return {
      Comment           = { fg = c.comment, style = opts.styles.comments },

      Constant          = { fg = c.const, style = opts.styles.constants },
      String            = { fg = c.string, style = opts.styles.strings },
      Character         = { link = "String" },
      Number            = { fg = c.const, style = opts.styles.numbers },
      Boolean           = { fg = c.const, style = opts.styles.booleans },
      Float             = { fg = c.const, style = opts.styles.floats },
      Identifier        = { fg = c.fg, style = opts.styles.variables },
      Function          = { fg = c.func, style = opts.styles.functions },

      Statement         = { link = "Keyword" },
      Conditional       = { fg = c.keyword, style = opts.styles.conditionals },
      Repeat            = { fg = c.keyword, style = opts.styles.loops },
      Label             = { fg = c.keyword, style = opts.styles.labels },
      Operator          = { link = "Keyword" },
      Keyword           = { fg = c.keyword, style = opts.styles.keywords },
      Exception         = { fg = c.keyword, style = opts.styles.exceptions },

      PreProc           = { link = "Keyword" },
      Include           = { link = "Keyword" },
      Define            = { link = "Keyword" },
      Macro             = { link = "Constant" },
      PreCondit         = { link = "Keyword" },

      Type              = { fg = c.keyword, style = opts.styles.types },
      StorageClass      = { link = "Keyword" },
      Structure         = { link = "Keyword" },
      Typedef           = { link = "Keyword" },

      Special           = { fg = c.fg },
      SpecialChar       = { link = "Special" },
      Tag               = { link = "Keyword" },
      Delimiter         = { fg = c.emphasis },
      SpecialComment    = { link = "Comment" },
      Debug             = { fg = c.const },

      Underlined        = { underline = true },

      Error             = { fg = c.danger },

      -- Todo              = { fg = c.fg, bg = c.bg , bold = true }, -- let Neovims handle this

      Added             = { fg = c.success },
      Changed           = { fg = c.changed },
      Removed           = { fg = c.danger },
    }
end

return M
