local M = {}

--- Get LSP highlight groups, see `:h lsp-highlight`
---@type koda.HighlightsFn
function M.get_hl(c)
  -- stylua: ignore
  return {
    DiagnosticError                          = { fg = c.danger },
    DiagnosticHint                           = { fg = c.info },
    DiagnosticInfo                           = { fg = c.fg },
    DiagnosticOK                             = { fg = c.success },
    DiagnosticWarn                           = { fg = c.warning },
    LspInlayHint                             = { fg = c.comment },
    ["@lsp.type.comment"]                    = {}, -- use treesitter styles
    ["@lsp.type.lifetime"]                   = { fg = c.const },
    ["@lsp.type.modifier"]                   = { link = "Keyword" },
    ["@lsp.type.struct"]                     = { fg = c.fg },
    ["@lsp.typemod.namespace.attribute"]     = { link = "Keyword" },
    ["@lsp.typemod.interface.declaration"]   = { fg = c.fg },
    ["@lsp.typemod.interface.public"]        = { fg = c.fg },
    ["@lsp.typemod.struct.declaration"]      = { fg = c.fg },
    ["@lsp.typemod.enum.declaration"]        = { fg = c.fg },
    ["@lsp.typemod.type.declaration"]        = { fg = c.fg },
    ["@lsp.typemod.class.declaration"]       = { fg = c.fg },
    ["@lsp.typemod.class.globalScope"]       = { fg = c.fg },
    ["@lsp.typemod.generic.attribute"]       = { fg = c.fg },
    ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
    -- ["@lsp.type.namespace"]                = { fg = c.keyword },
  }
end

return M
