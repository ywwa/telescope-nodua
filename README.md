# telescope-nodua
simple telescope.nvim plugin to run node scripts


### dependencies
* nvim-telescope/[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
* NvChad/[ui](https://github.com/nvchad/ui) *branch v3.0!

### installation
using lazy:

add as a dependency
```lua
{
    "nvim-telescope/telescope.nvim",
    ...,
    dependencies = {
        {"ywwa/telescope-nodua"}
    }
}
```
then load it using
```lua
require('telescope').load_extension('nodua')
```

### todo
* add option to override `spawnTerminal(entry)` function
    - currently its hardcoded to use nvchads terminal function

