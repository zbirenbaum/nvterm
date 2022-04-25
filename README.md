# NvChad Official Terminal Plugin

## Setup

### Installation

Simply install the plugin with packer as you would for any other:

```
use {
  "NvChad/nvterm",
  config = function ()
    require("nvterm").setup()
  end,
}
```

### Configuration
Pass a table of configuration options to the plugin's `.setup()` function above.
A sample configuration table with the default options is shown below:

```lua
require("nvterm").setup({
  terminals = {
    list = {},
    type_opts = {
      float = {
        relative = 'editor',
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = .3, },
      vertical = { location = "rightbelow", split_ratio = .5 },
    }
  },
  behavior = {
    close_on_exit = true,
    auto_insert = true,
  },
  mappings = {
    toggle = {
      float = "<A-i>",
      horizontal = "<A-h>",
      vertical = "<A-v>",
    },
    new = {
      horizontal = "<C-h>",
      vertical = "<C-v>",
    },
  },
  enable_new_mappings = false,
})
```

```
By default, the mappings for creating a new terminal rather than toggling the current one are disabled.
If `enable_new_mappings` is set to true, `new` will be set to any mappings passed in the configuration table under `new` or the defaults.
```
A shortcut is available for setting options of the different terminal types and mappings:
```lua
require("nvterm").setup({
  float = {
    relative = 'editor',
    row = 0.3,
    col = 0.25,
    width = 0.5,
    height = 0.4,
    border = "single",
  },
  horizontal = { location = "rightbelow", split_ratio = .3, },
  vertical = { location = "rightbelow", split_ratio = .5 },
  mappings{
    toggle {
      horizontal = "<A-s>"
    }
  }
})
```

is equivalent to:

```lua
require("nvterm").setup({
  terminals = {
    type_opts = {
      float = {
        relative = 'editor',
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = .3, },
      vertical = { location = "rightbelow", split_ratio = .5 },
    },
  },
  toggle {
    horizontal = "<A-s>",
  },
})
```

### Additional Functionality

NvTerm provides an api for you to send commands to the terminal. You can create different ones for different filetypes like so:
```lua
require("nvterm").setup()

local terminal = require("nvterm.terminal")

local ft_cmds = {
  python = "python3 " .. vim.fn.expand('%'),
  ...
  <your commands here>
}
local mappings = {
  { 'n', '<C-l>', function () terminal.send(ft_cmds[vim.bo.filetype]) end },
  { 'n', '<Leader>s', function () terminal.toggle('horizontal') end },
  { 'n', '<Leader>v', function () terminal.toggle('vertical') end },
}
local opts = { noremap = true, silent = true }
for _, mapping in ipairs(mappings) do
  vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
end
```

`terminal.send` also takes a 'type' parameter, so you can choose what type of terminal to send the command to.
By default, it runs the command in the last opened terminal, or a vertical one if none exist.
`terminal.send(ft_cmds[vim.bo.filetype], "float")` will run the command in a floating terminal

