# NvChad Official Terminal Plugin

## Setup:

### Installation:

Simply install the plugin with packer as you would for any other:

```
use {
  "NvChad/nvterm",
  config = function ()
    require("nvterm").setup()
  end,
}
```

### Configuration:
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
      { '<A-i>', function () terminal.new_or_toggle('float') end },
      { '<A-s>', function () terminal.new_or_toggle('horizontal') end },
      { '<A-v>', function () terminal.new_or_toggle('vertical') end },
    }
  }
})
```
### Additional Functionality:

NvTerm provides an api for you to send commands to the terminal. You can create different ones for different filetypes like so:
```
require("nvterm").setup()

local terminal = require("nvterm.terminal")

local ft_cmds = {
  python = "python3 " .. vim.fn.expand('%'),
  ...
  <your commands here>
}
local mappings = {
  { 'n', '<C-l>', function () terminal.send(ft_cmds[vim.bo.filetype]) end },
  { 'n', '<Leader>s', function () terminal.new_or_toggle('horizontal') end },
  { 'n', '<Leader>v', function () terminal.new_or_toggle('vertical') end },
}
for _, mapping in ipairs(mappings) do
  vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
end
```

`terminal.send` also takes a 'type' parameter, so you can choose what type of terminal to send the command to.
By default, it runs the command in the last opened terminal, or a vertical one if none exist.
`terminal.send(ft_cmds[vim.bo.filetype], "float")` will run the command in a floating terminal

