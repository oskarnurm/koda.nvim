<div align="center">
  <h1>Koda</h1>
  <p>Code's quiet companion</p>
    <p>A minimalist theme for <a href="https://github.com/neovim/neovim">Neovim</a>, written in Lua</p>
</div>
<img src="https://github.com/user-attachments/assets/7a42056d-c0ff-4df9-8ed5-eea39f5b7619#.png" width="1509" height="1186" alt="koda"  />

## Previews

<details>
<summary>Dark</summary>
<img src="https://github.com/user-attachments/assets/747e4c95-1215-43c6-ae4a-72298edea919"/>
</details>
<details>
<summary>Light</summary>
<img src="https://github.com/user-attachments/assets/1be34f5b-2e5c-4c50-908f-30969b19d551"/>
</details>
<details>
<summary>Moss</summary>
<img src="https://github.com/user-attachments/assets/6fec3064-d1c1-4969-8e16-998bde838a1f"/>
</details>
<details>
<summary>Glade</summary>
<img src="https://github.com/user-attachments/assets/3d129c05-5deb-40a8-bda2-9e15ae929cf6" />
</details>

<!--
## Features

- **Minimalist design**: easy on the eyes while providing a clear semantic distinction.
- **Fast**: caches the theme for blazingly fast startup times.
- **Lean**: skips highlights for plugins that aren't installed.
- Supports stable and the latest [Neovim 0.12](https://neovim.io/roadmap/) features.

<details id="plugin-support">
  <summary>Supported plugins</summary>

> Please open an issue if you notice any problems, or if a plugin you think should have explicit support is missing from the list.

- [blink.cmp](https://github.com/saghen/blink.cmp)
- [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim)
- [flash.nvim](https://github.com/folke/flash.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [mason.nvim](https://github.com/mason-org/mason.nvim)
- [mini.pick](https://github.com/nvim-mini/mini.pick)
- [mini.statusline](https://github.com/nvim-mini/mini.statusline)
- [mini.icons](https://github.com/nvim-mini/mini.icons?tab=readme-ov-file)
- [mini.jump2d](https://github.com/nvim-mini/mini.jump2d)
- [modes.nvim](https://github.com/mvllow/modes.nvim)
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [snacks.dashboard](https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md)
- [snacks.input](https://github.com/folke/snacks.nvim/blob/main/docs/input.md)
- [snacks.notifier](https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md)
- [snacks.picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [trouble.nvim](https://github.com/folke/trouble.nvim)

</details>
-->

## Installation

Using [lazy.nvim:](https://github.com/folke/lazy.nvim)

```lua
{
  "oskarnurm/koda.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- require("koda").setup({ transparent = true })
    vim.cmd("colorscheme koda")
  end,
}
```

Using [vim.pack:](https://neovim.io/doc/user/pack.html#vim.pack)

```lua
vim.pack.add({
  "https://github.com/oskarnurm/koda.nvim",
})
-- require("koda").setup({ transparent = true })
vim.cmd("colorscheme koda")
```

## Usage

> By default, `koda` will automatically switch between dark and light variants based on your `vim.o.background` setting. You can configure which variant during `setup()`.

```lua
vimd.cmd("colorscheme koda") -- auto-switches based on background
```

```vim
" Explicitly set a variant:
colorscheme koda-dark
colorscheme koda-light
colorscheme koda-moss
colorscheme koda-glade
```

## Default Configuration

> [!IMPORTANT]
> Configure setup **BEFORE** calling `vim.cmd("colorscheme koda")`.

```lua
require("koda").setup({
    transparent = false, -- enable for transparent backgrounds

    -- Set the variants to use when auto-switching based on vim.o.background
    -- Valid values: 'dark', 'light', 'moss', 'glade'
    theme = {
      dark = "dark",
      light = "light",
    },

    -- Automatically enable highlights only for plugins installed by your plugin manager
    -- Currently only supports `lazy.nvim`, `mini.deps` and `vim.pack`
    auto = true,  -- disable to load ALL available plugin highlights

    cache = true, -- caches the theme for better performance

    -- Style to be applied to different syntax groups
    -- Common use case would be to set either `italic = true` or `bold = true` for a desired group
    -- See `:help nvim_set_hl` for more valid values
    styles = {
       functions = { bold = true },
       keywords  = {},
       comments  = {},
       strings   = {},
       constants = {}, -- includes numbers, booleans
    },

    -- Override colors for the active variant
    -- Available keys (e.g., 'func') can be found in lua/koda/palette/
    colors = {
      -- func = "#4078F2",
      -- keyword = "#A627A4",
    },

    -- You can modify or extend highlight groups using the `on_highlights` configuration option
    -- Any changes made take effect when highlights are applied
    on_highlights = function(hl, c)
      -- hl.LineNr = { fg = c.info } -- change a specific highlight to use a different palette color
      -- hl.Comment = { fg = c.emphasis, italic = true } -- modify a syntax group (add bold, italic, etc)
      -- hl.RainbowDelimiterRed = { fg = "#fb2b2b" } -- add a custom highlight group for another plugin
    end,
})

```

## API

Koda exposes a few utility functions to allow users to integrate the theme with other parts of their configuration.

```lua
local koda = require("koda")
local colors = koda.get_palette("dark") -- returns the colors for the given theme with user-overrides applied

some_plugin.error = koda.blend(colors.danger, colors.bg, 0.3) -- blends two colors together. Useful for creating custom shades that match the theme
```

You can also manually clear Koda's cache and reload the highlights by running:

```vim
:KodaFetch
```

## Supported Plugins

- [blink.cmp](https://github.com/saghen/blink.cmp)
- [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim)
- [flash.nvim](https://github.com/folke/flash.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [mason.nvim](https://github.com/mason-org/mason.nvim)
- [mini.pick](https://github.com/nvim-mini/mini.pick)
- [mini.statusline](https://github.com/nvim-mini/mini.statusline)
- [mini.icons](https://github.com/nvim-mini/mini.icons?tab=readme-ov-file)
- [mini.jump2d](https://github.com/nvim-mini/mini.jump2d)
- [modes.nvim](https://github.com/mvllow/modes.nvim)
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [snacks.dashboard](https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md)
- [snacks.input](https://github.com/folke/snacks.nvim/blob/main/docs/input.md)
- [snacks.notifier](https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md)
- [snacks.picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [trouble.nvim](https://github.com/folke/trouble.nvim)

## Language support

Most languages have sensible defaults thanks to Neovim's built-in queries, so I've opted not to add anything language-specific to keep the footprint smaller. Feel free to open an issue.

## Extras

Extra color configs for [WezTerm](https://wezterm.org/), [Ghostty](https://ghostty.org/), [Lazygit](https://github.com/jesseduffield/lazygit), [fzf](https://github.com/junegunn/fzf) and others can be found in [extras](extras/). To use them, refer to their respective documentation.
