local M = {}

M.cache = {}

--- Reads a file from disk
---@param fname string
---@return string|nil, string|nil
function M.read(fname)
  local file, err = io.open(fname, "r")
  if not file then
    return nil, err
  end
  local data = file:read("*a")
  file:close()
  return data
end

--- Writes to the given file, erasing all previous data.
---@param fname string
---@param data string
function M.write(fname, data)
  vim.fn.mkdir(vim.fs.dirname(fname), "p")
  local file = assert(io.open(fname, "w+"))
  file:write(data)
  file:close()
end

--- Returns the path to the cache file for a given key
---@param key string
---@return string
function M.cache.file(key)
  return vim.fs.joinpath(vim.fn.stdpath("cache"), "koda-" .. key .. ".json")
end

--- Safely read and decode the cached file from disk
---@param key string
---@return koda.Cache|nil
function M.cache.read(key)
  local data = M.read(M.cache.file(key))
  if not data then
    return nil
  end
  local is_ok, ret = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
  return is_ok and ret or nil
end

--- Encodes and writes data to the cached directory
---@param key string
---@param data koda.Cache
function M.cache.write(key, data)
  pcall(M.write, M.cache.file(key), vim.json.encode(data))
end

--- Deletes Koda's cache files from the system
function M.cache.clear()
  local files = vim.fn.glob(vim.fn.stdpath("cache") .. "/koda-*.json", false, true)
  for _, file in ipairs(files) do
    vim.uv.fs_unlink(file)
  end
end

--- Unpacks the style table into main highlight groups
---@param groups koda.Highlights
---@return koda.Highlights
function M.unpack(groups)
  for _, hl in pairs(groups) do
    if hl.style and type(hl.style) == "table" then
      for k, v in pairs(hl.style) do
        hl[k] = v
      end
      hl.style = nil
    end
  end
  return groups
end

--- Converts a hex color string to an RGB table
---@param hex string A hex color string like "#RRGGBB"
---@return table
local function rgb(hex)
  hex = hex:lower()
  return {
    tonumber(hex:sub(2, 3), 16),
    tonumber(hex:sub(4, 5), 16),
    tonumber(hex:sub(6, 7), 16),
  }
end

--- Blends two colors based on alpha transparency
---@param foreground string Foreground hex color
---@param background string Background hex color
---@param alpha number Blend factor (0 to 1)
---@return string # A hex color string like "#RRGGBB"
function M.blend(foreground, background, alpha)
  local fg = rgb(foreground)
  local bg = rgb(background)

  local function blend_channel(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blend_channel(1), blend_channel(2), blend_channel(3))
end

-- Clears cache and reloads the current colorscheme
function M.reload()
  M.cache.clear()
  for name, _ in pairs(package.loaded) do
    if name:match("^koda") and name ~= "koda.config" then
      package.loaded[name] = nil
    end
  end
  vim.notify("Koda reloaded", vim.log.levels.WARN)
  vim.cmd.colorscheme(vim.g.colors_name)
end

--- Resolves the current theme variant based on user config and background settings
---@param theme string|nil
---@return string
function M.resolve(theme)
  if theme then
    return theme
  end
  -- Fall back to `vim.o.background` when faulty values are passed to theme = {} during setup
  local ret = require("koda.config").options.theme[vim.o.background] or vim.o.background
  return ret
end

return M
