local M = {}

local defaults = {
  terminals = {
    list = {},
    type_opts = {
      float = {
        relative = "editor",
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
      horizontal = { location = "rightbelow", split_ratio = 0.3 },
      vertical = { location = "rightbelow", split_ratio = 0.5 },
    },
  },
  behavior = {
    close_on_exit = true,
    auto_insert = true,
  },
}

local set_behavior = function(behavior)
  if behavior.close_on_exit then
    vim.api.nvim_create_autocmd({ "TermClose" }, {
      callback = function()
        vim.schedule_wrap(vim.api.nvim_input("<CR>"))
      end,
    })
  end

  if behavior.auto_insert then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      callback = function()
        vim.cmd("startinsert")
      end,
      pattern = "term://*",
    })

    vim.api.nvim_create_autocmd({ "BufLeave" }, {
      callback = function()
        vim.cmd("stopinsert")
      end,
      pattern = "term://*",
    })
  end
end

M.setup = function(config)
  config = config and vim.tbl_deep_extend("force", defaults, config) or defaults

  set_behavior(config.behavior)
  require("nvterm.terminal").init(config.terminals)
end

return M
