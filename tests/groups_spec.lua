local Utils = require("koda.utils")
local Palette = require("koda.palette.dark")
local Groups = require("koda.groups")

describe("The colorscheme", function()
  it("can require every file in koda/groups without syntax errors", function()
    local path = "lua/koda/groups"
    local files = vim.split(vim.fn.glob(path .. "/*.lua"), "\n")
    for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ":t:r")
      if name ~= "init" then
        local ok, mod = pcall(require, "koda.groups." .. name)

        assert.is_true(ok, "Failed to load file: " .. name)
        assert.is_table(mod, "Module " .. name .. " did not return a table")
      end
    end
  end)
end)

describe("Plugin detection logic", function()
  local colors = Palette
  local original_api = vim.pack

  before_each(function()
    package.loaded["lazy"] = nil
    package.loaded["lazy.core.config"] = nil
    package.loaded["koda.utils"] = nil
    package.loaded["koda.groups"] = nil
    vim.pack = original_api
    Utils.cache.clear()
  end)

  it("loads only base groups when package APIs are absent", function()
    local temp_pack = vim.pack
    local temp_mini = _G.MiniDeps
    vim.pack = false
    _G.MiniDeps = false

    local Config = require("koda.config")
    local opts = Config.extend({ auto = true })
    local _, loaded = Groups.setup(colors, opts, "dark")

    -- Restore
    vim.pack = temp_pack
    _G.MiniDeps = temp_mini

    assert.is_true(loaded["base"], "base group should be loaded")
    assert.is_nil(loaded["gitsigns"], "gitsigns should NOT be loaded")
  end)

  it("loads only base groups when auto=true, but vim.pack is empty and other package APIs are absent", function()
    -- Mock vim.pack to return an empty plugin list
    vim.pack = {
      get = function()
        return {}
      end,
    }
    local Config = require("koda.config")
    local opts = Config.extend({ auto = true })
    local _, loaded = Groups.setup(colors, opts, "dark")

    assert.is_true(loaded["base"], "base group should be loaded")
    assert.is_nil(loaded["gitsigns"], "gitsigns should NOT be loaded")
  end)

  it("loads all plugins when auto=false", function()
    local Config = require("koda.config")
    local opts = Config.extend({ auto = false })
    local _, loaded = Groups.setup(colors, opts)

    assert.is_true(loaded["telescope"], "Telescope should be loaded")
    assert.is_true(loaded["blink"], "Blink should be loaded")
  end)

  it("respects lazy.nvim detection", function()
    package.loaded.lazy = true
    package.loaded["lazy.core.config"] = {
      plugins = {
        ["telescope.nvim"] = { name = "telescope.nvim" },
      },
    }
    local Config = require("koda.config")
    local opts = Config.extend({ auto = true })
    local _, loaded = Groups.setup(colors, opts)

    assert.is_true(loaded["telescope"], "Telescope should be loaded")
    assert.is_nil(loaded["blink.cmp"], "Blink should NOT be loaded")
  end)

  it("respects vim.pack detection", function()
    package.loaded["lazy"] = nil
    package.loaded["lazy.core.config"] = nil
    vim.pack = {
      get = function()
        return {
          {
            active = true,
            spec = { name = "blink.cmp" },
          },
        }
      end,
    }
    local Config = require("koda.config")
    local opts = Config.extend({ auto = true })
    local _, loaded = Groups.setup(colors, opts)

    assert.is_true(loaded["blink"], "Blink should be loaded via vim.pack")
    assert.is_nil(loaded["telescope"], "Telescope should NOT be loaded")
  end)
end)
