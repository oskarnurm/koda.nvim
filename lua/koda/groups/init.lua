local Utils = require("koda.utils")
local Config = require("koda.config")

local M = {}

-- stylua: ignore
M.plugins = {
  ["blink.cmp"]                = "blink",
  ["mason.nvim"]               = "mason",
  ["rainbow-delimiters.nvim"]  = "rainbow-delimiters",
  ["mini.nvim"]                = "mini",
  ["modes.nvim"]               = "modes",
  ["oil.nvim"]                 = "oil",
  ["dashboard-nvim"]           = "dashboard",
  ["flash.nvim"]               = "flash",
  ["fzf-lua"]                  = "fzf",
  ["gitsigns.nvim"]            = "gitsigns",
  ["render-markdown.nvim"]     = "render-markdown",
  ["snacks.nvim"]              = "snacks",
  ["telescope.nvim"]           = "telescope",
  ["trouble.nvim"]             = "trouble",
  ["neo-tree.nvim"]            = "neotree",
}

--- Gets highlights from a specific group
---@param name string
---@param colors koda.Palette
---@param opts koda.Config
---@return koda.Highlights
function M.get_highlights(name, colors, opts)
  return require("koda.groups." .. name).get_hl(colors, opts)
end

---@param colors koda.Palette
---@param opts koda.Config
---@return koda.Highlights
---@return table
function M.setup(colors, opts, theme)
  -- Always load base groups
  local groups = {
    base = true,
    syntax = true,
    treesitter = true,
    lsp = true,
  }

  -- Load highlights only for plugins managed by plugin managers
  -- Currently only supports lazy.nvim and vim.pack
  -- Setting `opts.auto=false` during setup will load all highlights
  if not opts.auto then
    for _, group in pairs(M.plugins) do
      groups[group] = true
    end
  else
    if package.loaded.lazy then -- try lazy.nvim
      local lazy_plugins = require("lazy.core.config").plugins
      for plugin, group in pairs(M.plugins) do
        if lazy_plugins[plugin] then
          groups[group] = true
        end
      end
      if not groups.mini then -- check standalone mini modules
        for plugin_name, _ in pairs(lazy_plugins) do
          if plugin_name:match("^mini%.") then
            groups.mini = true
            break
          end
        end
      end
    end
    if vim.pack then -- try vim.pack
      local ok, packdata = pcall(vim.pack.get, nil, { info = false })
      if ok and packdata then
        for _, plugin in ipairs(packdata) do
          local group = M.plugins[plugin.spec.name]
          if group then
            groups[group] = true
          end
          if not groups.mini and plugin.spec.name:match("^mini%.") then
            groups.mini = true
          end
        end
      end
    end
    if _G.MiniDeps then -- try mini.deps
      for _, plugin in ipairs(_G.MiniDeps.get_session()) do
        if M.plugins[plugin.name] then
          groups[M.plugins[plugin.name]] = true
        end
        if not groups.mini and plugin.name:match("^mini%.") then
          groups.mini = true
        end
      end
    end
  end

  -- Sort (in-place) group names for consistent cache keys
  local names = vim.tbl_keys(groups)
  table.sort(names)

  local config = {
    colors = colors,
    plugins = names,
    version = Config._version,
    opts = {
      styles = opts.styles,
      colors = opts.colors,
      transparent = opts.transparent,
    },
  }

  -- Check if we can use cached highlights
  local cache_key = theme or vim.o.background
  local cache = opts.cache and Utils.cache.read(cache_key)
  local hl = cache and vim.deep_equal(config, cache.config) and cache.groups

  -- Generate highlights if cache miss
  if not hl then
    hl = {}
    for group in pairs(groups) do
      for k, v in pairs(M.get_highlights(group, colors, opts)) do
        hl[k] = v
      end
    end
    Utils.unpack(hl)
    if opts.cache then
      Utils.cache.write(cache_key, { groups = hl, config = config })
    end
  end
  opts.on_highlights(hl, colors)

  return hl, groups -- return groups table for testing purposes
end

return M
