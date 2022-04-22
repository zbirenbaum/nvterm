local M = {}

local terminal = require("nvterm.terminal")

local defaults = {
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
}

local set_behavior = function(behavior)
  if behavior.close_on_exit then
    vim.api.nvim_create_autocmd({"TermClose"},{
      callback = function()
        vim.schedule_wrap(vim.api.nvim_input('<CR>'))
      end
    })
  end
  if behavior.auto_insert then
    vim.api.nvim_create_autocmd({"BufEnter"}, {
      callback = function() vim.cmd('startinsert') end,
      pattern = 'term://*'
    })
    vim.api.nvim_create_autocmd({"BufLeave"}, {
      callback = function() vim.cmd('stopinsert') end,
      pattern = 'term://*'
    })
  end
end

local create_mappings = function (mappings)
  local opts = { noremap = true, silent = true }
  for _, mapping in ipairs(mappings.toggle) do
    vim.keymap.set({'n', 't'}, mapping[1], mapping[2], opts)
  end
end

M.setup = function (config)
  config = config and vim.tbl_deep_extend("force", config, defaults) or defaults
  set_behavior(config.behavior)
  create_mappings(config.mappings)
  terminal.init(config.terminals)
end

return M
