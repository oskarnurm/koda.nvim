local variants = { "dark", "light", "moss", "glade" }

-- Every key from the koda.Palette type that group files reference.
-- A missing key here means silent `nil` foregrounds/backgrounds at runtime.
local required_keys = {
  "bg", "fg", "dim", "line",
  "keyword", "type", "operator", "comment", "border",
  "emphasis", "func", "string", "char", "special", "const",
  "highlight", "info", "success", "warning", "danger",
  "green", "orange", "red", "pink", "cyan",
}

describe("Palette integrity:", function()
  for _, name in ipairs(variants) do
    describe(name .. ":", function()
      local palette

      before_each(function()
        -- Clear cached module to get a fresh load
        package.loaded["koda.palette." .. name] = nil
        palette = require("koda.palette." .. name)
      end)

      it("exports a table", function()
        assert.is_table(palette, name .. " palette should return a table")
      end)

      for _, key in ipairs(required_keys) do
        it("has '" .. key .. "' as a valid hex color", function()
          local value = palette[key]
          assert.is_not_nil(value, name .. " palette is missing key: " .. key)
          assert.is_truthy(
            tostring(value):match("^#%x%x%x%x%x%x$"),
            name .. "." .. key .. " is not a valid hex color: " .. tostring(value)
          )
        end)
      end
    end)
  end
end)
