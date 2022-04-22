# NvChad Official Terminal Plugin

## Setup:

### Installation:

Simply install the plugin with packer as you would for any other:

```
use {
  "NvChad/chadterm",
  config = function ()
    require("chadterm").setup()
  end,
}
```

### Configuration:
Pass a table of configuration options to the plugin's `.setup()` function above.
A sample configuration table with the default options is shown below:

```lua
require("chadterm").setup({
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
