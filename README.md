<div align="center"><h1>Koda</h1></div>
<p align="center">Code's quiet companion.</p>
<p align="center"> A minimalist theme for Neovim, written in Lua.</p>

### Dark
<img width="1127" height="746" alt="Screenshot 2026-01-07 at 21 34 20" src="https://github.com/user-attachments/assets/e892c373-ebc2-436d-8efa-7d1fd3d1f1a7" />
<!-- <img width="1170" height="772" alt="koda-dark-orange-gradient-2026-01-08" src="https://github.com/user-attachments/assets/c307a633-f103-4260-a707-4e549429a91b" /> -->

### Light
<img width="1127" height="746" alt="Screenshot 2026-01-07 at 21 36 22" src="https://github.com/user-attachments/assets/02a71d9a-3067-4bce-a535-afebb1e190dc" />
<!-- <img width="1170" height="772" alt="koda-light-orange-gradient-2026-01-08" src="https://github.com/user-attachments/assets/82c11bf2-35dd-4cb1-be3e-b46ad03ca5e0" /> -->

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
    -- require("koda").setup({ transparent = true })
    vim.cmd("colorscheme koda")
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
> Set the configuration **BEFORE** calling `vim.cmd("colorscheme koda")`.

> Because the theme uses the same background for pop-up menus and floating windows, I recommend setting both `winborder` and `pumborder` to _at least_ "single" in your configs.


<details>
  <summary>Default Options</summary>
  
```lua
require("koda").setup({
    bold = true,          -- disable bold for functions and keywords
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

</details>

<details>
  <summary>Settings & Changing Colors</summary>

```lua
require("koda").setup({
  bold = false,
  -- For example, add more colors to the theme by changing `func` and `keyword` colors:
  colors = {
    func = "#4078F2",
    keyword = "#A627A4",
  },
})
```

</details>


## Plugin support
**NOTE:** I only took the effort to make adjustments for a few plugins. I don't use many, so I am out of touch. Open an issue if something is severely off.

- [blink.cmp](https://github.com/saghen/blink.cmp)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [mini.pick](https://github.com/nvim-mini/mini.pick)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)

## Language support
I feel like most languages have sensible defaults thanks to Neovim's built-in queries, so I've opted not to add anything specific for a language in favor of keeping the footprint smaller.
