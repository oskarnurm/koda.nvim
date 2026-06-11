local Utils = require("koda.utils")
local Config = require("koda.config")

describe("Utils.blend", function()
  it("returns the foreground at alpha=1", function()
    local result = Utils.blend("#FF0000", "#0000FF", 1)
    assert.are.equal("#FF0000", result)
  end)

  it("returns the background at alpha=0", function()
    local result = Utils.blend("#FF0000", "#0000FF", 0)
    assert.are.equal("#0000FF", result)
  end)

  it("blends to midpoint at alpha=0.5", function()
    -- #000000 + #FF FF FF at 0.5 → each channel = 127.5 → rounds to 128 = 0x80
    local result = Utils.blend("#000000", "#FFFFFF", 0.5)
    assert.are.equal("#808080", result)
  end)

  it("handles identical colors at any alpha", function()
    local color = "#ABCDEF"
    assert.are.equal("#ABCDEF", Utils.blend(color, color, 0))
    assert.are.equal("#ABCDEF", Utils.blend(color, color, 0.5))
    assert.are.equal("#ABCDEF", Utils.blend(color, color, 1))
  end)

  it("clamps channels to the 0-255 range", function()
    -- Even with extreme inputs, result should still be a valid hex color
    local result = Utils.blend("#FFFFFF", "#FFFFFF", 1)
    assert.are.equal("#FFFFFF", result)
  end)

  it("returns a 7-character hex string", function()
    local result = Utils.blend("#123456", "#654321", 0.3)
    assert.is_truthy(result:match("^#%x%x%x%x%x%x$"), "Expected '#RRGGBB', got: " .. result)
  end)
end)

describe("Utils.unpack", function()
  it("flattens style table into the highlight", function()
    local groups = {
      TestGroup = { fg = "#ffffff", style = { bold = true, italic = true } },
    }
    local result = Utils.unpack(groups)

    assert.is_true(result.TestGroup.bold)
    assert.is_true(result.TestGroup.italic)
    assert.is_nil(result.TestGroup.style, "style key should be removed after unpacking")
  end)

  it("leaves highlights without a style key untouched", function()
    local groups = {
      Plain = { fg = "#aaaaaa", bg = "#000000" },
    }
    local result = Utils.unpack(groups)

    assert.are.equal("#aaaaaa", result.Plain.fg)
    assert.are.equal("#000000", result.Plain.bg)
    assert.is_nil(result.Plain.style)
  end)

  it("handles an empty style table", function()
    local groups = {
      Empty = { fg = "#111111", style = {} },
    }
    local result = Utils.unpack(groups)

    assert.are.equal("#111111", result.Empty.fg)
    assert.is_nil(result.Empty.style)
  end)

  it("does not clobber existing attributes when style overlaps", function()
    local groups = {
      Overlap = { fg = "#aaaaaa", bold = false, style = { bold = true } },
    }
    local result = Utils.unpack(groups)

    -- style values should win because they're applied after
    assert.is_true(result.Overlap.bold)
  end)
end)

describe("Utils.resolve", function()
  before_each(function()
    Config.setup()
  end)

  it("returns the explicit theme when provided", function()
    assert.are.equal("moss", Utils.resolve("moss"))
  end)

  it("falls back to config theme for current background", function()
    Config.setup({ theme = { dark = "moss", light = "glade" } })

    vim.o.background = "dark"
    assert.are.equal("moss", Utils.resolve())

    vim.o.background = "light"
    assert.are.equal("glade", Utils.resolve())
  end)

  it("falls back to vim.o.background when config has no mapping", function()
    -- Simulate a config where the theme table lacks the current background key
    Config.setup({ theme = {} })

    vim.o.background = "dark"
    assert.are.equal("dark", Utils.resolve())
  end)
end)
