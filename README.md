<div align="center"><h1>Koda</h1></div>
<p align="center">Code's quiet companion.</p>
<p align="center"> A minimalist theme for Neovim, written in Lua.</p>

<img width="1510" height="943" alt="koda-dark-bigger-2026-01-07" src="https://github.com/user-attachments/assets/8aba84e5-519d-4a2f-8632-7387e4da4cc2" />
<img width="1510" height="943" alt="koda-light-bigger-2026-01-07" src="https://github.com/user-attachments/assets/bfa5d1e1-1afa-4645-a7d8-c4d6b519dcd0" />

> [!NOTE]
> Developed on a 14" XDR retina display, your mileage may vary depending on your screen and brightness.

## Installation

[lazy.nvim:](https://github.com/folke/lazy.nvim)

```lua
{
  "oskarnurm/koda.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    vim.cmd("colorscheme koda") -- NOTE: no setup() required
  end,
}
```

[vim.pack:](https://neovim.io/doc/user/pack.html#vim.pack)

```lua
vim.pack.add({
  "https://github.com/oskarnurm/koda.nvim",
})

vim.cmd("colorscheme koda")
```

## Configuration
> [!IMPORTANT]
> Configure options _before_ setting the colorscheme by calling `setup` before `vim.cmd("colorscheme koda")` for changes to take effect. 

You can call `setup` if you wish to override the following defaults:
```lua
require("koda").setup({
    bold = true           -- disable bold for functions and keywords
    italic = false,       -- enable italics for comments and strings
    transparent = false,  -- enable for transparent backgrounds

    -- Override colors
    -- These will be merged into the active palette (Dark or Light)
    -- Example colors for dark background:
    colors = {
        none        = "none",
        bg_solid    = "#101010",
        bg          = "#101010",
        fg          = "#b0b0b0",
        line        = "#272727",
        paren       = "#4d4d4d",
        keyword     = "#777777",
        dim         = "#50585d",
        comment     = "#50585d",
        border      = "#ffffff",
        emphasis    = "#ffffff",
        func        = "#ffffff",
        string      = "#ffffff",
        const       = "#d9ba73",
        highlight   = "#0058d0",
        info        = "#8ebeec",
        success     = "#86cd82",
        warning     = "#d9ba73",
        danger      = "#ff7676",
    }
})
```

<!--
## Color Groups

When overriding colors, you can use any of the following keys from the colors palette:

| Key      | Description                                |
| -------- | ------------------------------------------ |
| bg       | Main editor background                     |
| fg       | Main editor foreground                     |
| func     | Functions and Headings                     |
| keyword  | Language keywords (`if`, `else`, `return`) |
| constant | Numbers, Booleans, and Constants           |
| comment  | Code comments                              |
| string   | String literals                            |
| line     | CursorLine and UI borders                  |
| visual   | Selection background                       |
| hint     | Diagnostic hints, directories              |
| error    | Error messages, delete                     |
| add      | Diff/git related add                       |
| change   | Diff/git related change                    |
-->

## Explicit Plugin support

- [blink.cmp](https://github.com/saghen/blink.cmp)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [mini.pick](https://github.com/nvim-mini/mini.pick)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
