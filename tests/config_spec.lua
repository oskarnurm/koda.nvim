local Config = require("koda.config")
local Koda = require("koda")

describe("Config.extend", function()
  it("returns defaults when given no arguments", function()
    local result = Config.extend()
    assert.are.same(Config.defaults, result)
  end)

  it("returns defaults when given an empty table", function()
    local result = Config.extend({})
    assert.are.same(Config.defaults, result)
  end)

  it("deep-merges user options over defaults", function()
    local result = Config.extend({
      transparent = true,
      styles = { keywords = { italic = true } },
    })

    assert.is_true(result.transparent)
    assert.is_true(result.styles.keywords.italic)
    -- Other style defaults should survive the merge
    assert.is_true(result.styles.functions.bold, "functions.bold default should be preserved")
  end)

  it("does not mutate the defaults table", function()
    local original_transparent = Config.defaults.transparent
    Config.extend({ transparent = true })

    assert.are.equal(original_transparent, Config.defaults.transparent)
  end)
end)

describe("Config.setup", function()
  after_each(function()
    Config.setup() -- restore defaults
  end)

  it("updates options with user config", function()
    Config.setup({ transparent = true })
    assert.is_true(Config.options.transparent)
  end)

  it("resets to defaults when called with no arguments", function()
    Config.setup({ transparent = true })
    Config.setup()
    assert.is_false(Config.options.transparent)
  end)
end)

describe("Config defaults", function()
  it("has a version string", function()
    assert.is_string(Config._version)
    assert.is_truthy(Config._version:match("^%d+%.%d+%.%d+$"), "Version should be semver: " .. Config._version)
  end)

  it("ships with expected default values", function()
    local d = Config.defaults
    assert.is_false(d.transparent)
    assert.is_true(d.auto)
    assert.is_true(d.cache)
    assert.are.equal("dark", d.theme.dark)
    assert.are.equal("light", d.theme.light)
    assert.is_function(d.on_highlights)
  end)
end)

describe("on_highlights callback", function()
  after_each(function()
    Config.setup()
  end)

  it("receives highlights and palette for user mutation", function()
    local captured_hl, captured_colors

    Config.setup({
      on_highlights = function(highlights, colors)
        captured_hl = highlights
        captured_colors = colors
      end,
    })

    vim.cmd("colorscheme koda")

    assert.is_table(captured_hl, "on_highlights should receive the highlights table")
    assert.is_table(captured_colors, "on_highlights should receive the palette")
    assert.is_not_nil(captured_hl.Normal, "highlights should contain Normal group")
    assert.is_not_nil(captured_colors.bg, "palette should contain bg")
  end)

  it("mutations in the callback are applied", function()
    Config.setup({
      on_highlights = function(highlights, _)
        highlights.Normal = { fg = "#FF00FF", bg = "#00FF00" }
      end,
    })

    vim.cmd("colorscheme koda")
    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })

    -- #FF00FF = 16711935, #00FF00 = 65280
    assert.are.equal(0xFF00FF, hl.fg, "on_highlights mutation should be applied to fg")
    assert.are.equal(0x00FF00, hl.bg, "on_highlights mutation should be applied to bg")
  end)
end)

describe("Color overrides via get_palette", function()
  after_each(function()
    Config.setup()
  end)

  it("applies custom color overrides to the palette", function()
    Config.setup({ colors = { bg = "#111111", fg = "#eeeeee" } })

    local palette = Koda.get_palette("dark")

    assert.are.equal("#111111", palette.bg)
    assert.are.equal("#eeeeee", palette.fg)
  end)

  it("preserves non-overridden palette colors", function()
    local original = Koda.get_palette("dark")
    Config.setup({ colors = { bg = "#111111" } })
    local modified = Koda.get_palette("dark")

    assert.are.equal("#111111", modified.bg)
    assert.are.equal(original.fg, modified.fg, "fg should be unchanged")
    assert.are.equal(original.keyword, modified.keyword, "keyword should be unchanged")
  end)
end)

describe("Transparent mode", function()
  after_each(function()
    Config.setup()
  end)

  it("sets Normal bg to 'none' when transparent=true", function()
    Config.setup({ transparent = true })
    vim.cmd("colorscheme koda")

    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    -- When bg is "none", nvim_get_hl returns no bg key at all
    assert.is_nil(hl.bg, "Normal bg should be nil (transparent)")
  end)

  it("sets a concrete bg when transparent=false", function()
    Config.setup({ transparent = false })
    vim.cmd("colorscheme koda")

    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    assert.is_not_nil(hl.bg, "Normal bg should be set")
  end)
end)
