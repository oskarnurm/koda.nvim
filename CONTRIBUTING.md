# Contributing to Koda

Thank you for your interest in contributing to Koda! Pull requests are welcome.

## General Contribution Guidelines

- Follow the existing code style
- Follow [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
- Update documentation if needed

### Available Colors

The `c` parameter contains all theme colors. It's best to use as few colors as possible, common colors to use include:

- `c.fg`, `c.bg` - main foreground/background
- `c.emphasis`, `c.const` - emphasise important stuff
- `c.info`, `c.success`, `c.warning`, `c.danger` - diagnostic colors
- `c.green`, `c.orange`, `c.red`, `c.pink`, `c.cyan`, `c.highlight` - color variations

For the complete list of available colors, refer to the [palette/](lua/koda/palette/).

### Highlight Attributes

Each highlight group can have these attributes:

- `fg` - foreground color
- `bg` - background color
- `bold` - boolean
- `italic` - boolean
- `underline` - boolean
- `undercurl` - boolean
- `strikethrough` - boolean
- `link` - link to another highlight group (e.g., `link = "Normal"`)

## Adding Extras

Refer to the [palette/](lua/koda/palette/) when setting colors. Koda follows a pretty minimal philosophy, so you should almost never need to define extra colors unless in very rare cases.

Please provide screenshots in your PR. It's best if you can compare your results with existing setups.

Below are example screenshots from Ghostty and WezTerm:

### How to Add Plugin Support

1. **Find the highlight groups**: Check the plugin's documentation, source code or your picker (if it supports it) to find the highlight group names it uses. Otherwise, you can do`:so $VIMRUNTIME/syntax/hitest.vim` to see active highlight groups.

2. **Create the plugin file**: Create a new file `lua/koda/groups/plugin-name.lua`:

Each plugin has its own file in `lua/koda/groups/` that defines the highlight groups for that plugin. A typical plugin module looks like this:

```lua
local M = {}

---@type koda.HighlightsFn
function M.get(c, opts)
  -- stylua: ignore
  return {
    HighlightGroup1 = { fg = c.fg, bg = c.bg },
    HighlightGroup2 = { fg = c.emphasis, bold = true },
    HighlightGroup3 = { link = "Normal" },
  }
end

return M
```

3. **Register the plugin**: Add an entry to the `M.plugins` table in `lua/koda/groups/init.lua`:

   ```lua
   M.plugins = {
     -- ... existing plugins ...
     ["plugin-name"]     = "plugin-name",  -- key is the plugin repo name, value is the group file name
   }
   ```

   The key should match the plugin's repository name (what you see in lazy.nvim or other plugin managers). The value is the filename (without `.lua`) you created in step 2.

4. **Test your changes**:
   - Install the plugin in your Neovim config
   - Load the Koda theme
   - Verify the highlights look good in all variants (dark/light)

5. **Follow the style guide**:
   - Use `-- stylua: ignore` before the return table to prevent formatting
   - Align highlight group names for readability (as shown in examples)
   - Group related highlights together
   - Add comments if the purpose of a highlight isn't obvious

### Tips for Choosing Colors

- Look at similar highlight groups in [base.lua](lua/koda/groups/base.lua) for consistency
- Use semantic colors (`c.success`, `c.warning`, etc.) for diagnostic-related highlights
- Use `c.emphasis`, `c.const` for standout text
- Use `c.comment`, `c.keyword` for muted text
- When in doubt, link to an existing group: `{ link = "Normal" }`

### Example: Adding a Simple Plugin

Here's a complete example for a fictional plugin called "cool-finder.nvim":

1. Create `lua/koda/groups/cool-finder.lua`:

```lua
local M = {}


---@type koda.HighlightsFn
function M.get(c, opts)
  -- stylua: ignore
  return {
    CoolFinderNormal   = { fg = c.fg, bg = c.bg },
    CoolFinderBorder   = { fg = c.emphasis },
    CoolFinderTitle    = { fg = c.info, bold = true },
    CoolFinderMatch    = { fg = c.const, bold = true },
    CoolFinderSelected = { fg = c.success, bg = utils.blend(c.green, c.bg, 0.2) },

  }
end

return M
```

2. Add to `lua/koda/groups/init.lua`:

```lua
M.plugins = {
  -- ... existing entries ...
  ["cool-finder.nvim"] = "cool-finder",
}
```

That's it! The plugin will now automatically be themed when loaded.

Thank you for contributing!
