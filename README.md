# chiefdog.nvim
A minimalist, _almost_ monochrome theme for Neovim. Named after me, for me, by me.

Because I cannot stand the [Christmas lights galore](https://tonsky.me/blog/syntax-highlighting/) that most themes are, and because I thought it would be more fun to make yet another one, inspired by others, barely different, but just right. 

Supports a few plugins, currently the ones I use, maybe will add support for more later if I find it necessary. 

Your mileage may vary depending on the quality of the screen you use. 
<img width="1355" height="796" alt="image" src="https://github.com/user-attachments/assets/987fd48f-d7a1-4d5e-8f1d-89e483c88eff" />

## Installation

**lazy.nvim**:

```lua
{
  "oskarnurm/chiefdog.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    vim.cmd("colorscheme chiefdog")
  end,
}
```

**vim.pack**:

```lua
vim.pack.add({
  "https://github.com/oskarnurm/chiefdog.nvim",
})

vim.cmd("colorscheme chiefdog")
```

## Plugin support:
- [blink.cmp](https://github.com/saghen/blink.cmp)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [mini.pick](https://github.com/nvim-mini/mini.pick)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
