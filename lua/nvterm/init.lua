local M = {}

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

M.create_mappings = function(method, map_table, opts)
  opts = opts or {}
  vim.tbl_deep_extend("force", { noremap = true, silent = true }, opts)
  for type, mapping in pairs(map_table) do
    vim.keymap.set({'n', 't'}, mapping, function ()
      require('nvterm.terminal')[method](type)
    end, opts)
  end
end

local setup_mappings = function (mappings)
  for method, map_table in pairs(mappings) do
    M.create_mappings(method, map_table)
  end
end

local map_config_shortcuts = function (config)
  local shortcuts = {
    { config.terminals.type_opts, { 'horizontal', 'vertical', 'float' } },
    { config.mappings, { 'toggle', 'new' } },
  }
  for _, shortcut_map in ipairs(shortcuts) do
    for _, key in ipairs(shortcut_map[2]) do
      shortcut_map[1][key] = vim.tbl_deep_extend("force", shortcut_map[1][key], config[key] or {})
    end
  end
  return config
end

M.setup = function (config)
  config = config and vim.tbl_deep_extend("force", defaults, config) or defaults
  set_behavior(config.behavior)
  config = map_config_shortcuts(config)
  config.mappings.new = config.enable_new_mappings and config.mappings.new or nil
  setup_mappings(config.mappings)
  require("nvterm.terminal").init(config.terminals)
end

return M
