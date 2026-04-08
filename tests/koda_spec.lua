local Config = require("koda.config")
local Utils = require("koda.utils")

describe("The colorscheme should:", function()
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
end)
