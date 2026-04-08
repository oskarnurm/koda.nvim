local Utils = require("koda.utils")
local Config = require("koda.config")

describe("Cache operations:", function()
  before_each(function()
    Utils.cache.clear()
  end)

  after_each(function()
    Utils.cache.clear()
  end)

  it("can read and write from the cache", function()
    local test_key = "test-key"
    local mock_data = {
      groups = { Normal = { fg = "#ffffff", bg = "#000000" } },
      config = { version = "1.0.0", plugins = {} },
    }

    Utils.cache.write(test_key, mock_data)
    local cached_data = Utils.cache.read(test_key)

    assert.is_not_nil(cached_data, "Cache read returned nil")
    assert.are.same(mock_data, cached_data, "Cached data does not match the written data")
  end)

  it("returns nil when reading non-existent cache", function()
    local cached_data = Utils.cache.read("not-cache-file")
    assert.is_nil(cached_data)
  end)

  it("clears cache successfully", function()
    -- Create dummy cache files
    Utils.cache.write("dummy-key-1", { foo = "bar" })
    Utils.cache.write("dummy-key-2", { fizz = "buzz" })

    -- Verify cache exists
    assert.is_not_nil(Utils.cache.read("dummy-key-1"))
    assert.is_not_nil(Utils.cache.read("dummy-key-2"))

    -- Clear cache
    Utils.cache.clear()

    assert.is_nil(Utils.cache.read("dummy-key-1"), "Cache 1 was not cleared")
    assert.is_nil(Utils.cache.read("dummy-key-2"), "Cache 2 was not cleared")
  end)

  it("generates new cache when config changes", function()
    vim.cmd("colorscheme koda-dark")

    local cache_before = Utils.cache.read("dark")
    assert.is_not_nil(cache_before, "Initial cache should be created")

    -- Change the config
    Config.setup({
      cache = true,
      styles = { keywords = { italic = true } },
    })

    -- Manually mimic`koda.load()` to generate new cache because of change
    local palette = require("koda.palette.dark")
    local _ = require("koda.groups").setup(palette, Config.options, "dark")

    local cache_after = Utils.cache.read("dark")

    assert.are_not.same(
      cache_before.config.opts.styles,
      cache_after.config.opts.styles,
      "Cache fingerprint did not update after config change"
    )
  end)
end)
