local Koda = require("koda")
local Config = require("koda.config")
local Utils = require("koda.utils")

describe("The colorscheme should", function()
  before_each(function()
    -- Clear cache and package.loaded before each test to test "cold start" logic
    Config.setup()
    Utils.reload()
  end)

  it("load without errors", function()
    local ok, err = pcall(vim.cmd, "colorscheme koda")

    assert.is_true(ok, "Colorscheme failed to load" .. tostring(err))
  end)

  it("apply correct highlights for Normal group", function()
    vim.cmd("colorscheme koda")
    local hl = vim.api.nvim_get_hl(0, { name = "Normal" })

    assert.is_not_nil(hl.fg, "Normal foreground should not be nil")
    assert.is_not_nil(hl.bg, "Normal background should not be nil")
  end)

  it("should generate a cache file", function()
    vim.cmd("colorscheme koda")
    local cache = Utils.cache.file(vim.o.background)
    local exists = vim.uv.fs_stat(cache)

    assert.is_truthy(exists, "Cache file was not created at " .. cache)
  end)

  describe("should automatically switch theme variant on background change", function()
    local initial_background = vim.o.background
    after_each(function()
      vim.o.background = initial_background
    end)

    local function compare()
      local expected = Koda.get_palette(Utils.resolve()).bg
      -- Format from decimal representation back to RGB hexadecimal (how palettes are represented).
      local actual = string.format("#%06x", vim.api.nvim_get_hl(0, { name = "Normal" }).bg)

      assert.are_equal(expected, actual, "Background (" .. vim.o.background .. ") values differ theme=" .. expected .. " bg=" .. actual)
    end

    local function toggle_bg()
      vim.o.background = vim.o.background == "dark" and "light" or "dark"
    end

    local cases = {
      ["default"] = {},
      ["alternative"] = {
        theme = {
          dark = "moss",
          light = "glade",
        },
      },
      ["always-dark"] = {
        theme = {
          dark = "dark",
          light = "dark",
        },
      },
    }

    for name, cfg in pairs(cases) do
      it(name, function()
        Config.setup(cfg)
        Utils.reload()
        vim.cmd("colorscheme koda")
        compare()
        toggle_bg()
        compare()
        toggle_bg()
        compare()
      end)
    end
  end)
end)
