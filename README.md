# telescope-nodua 

simple telescope extesion to run node scripts

yet not fully finnished yet

## Usage

1. Open using command `:Telescope nodua`
2. Select desired script and press enter

To hide terminal just repeat same process (TODO: add mapping)

#### Dependencies

self explanatory dependency

- nvim-telescope/[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

### Installation

#### Lazy:

add as a dependency

```lua
{
  "nvim-telescope/telescope.nvim",
  ...,
  dependencies = { "ywwa/telescope-nodua" }
}
```

then load it using

```lua
require('telescope').load_extension('nodua')
```

### Todo

- add option to override `toggle(opts)` function
- add mapping to hide opened terminal
