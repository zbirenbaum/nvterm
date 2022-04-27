local util = require "nvterm.termutil"
local a = vim.api
local nvterm = {}
local terminals = {}

local function get_last(list)
   if list then
      return not vim.tbl_isempty(list) and list[#list] or nil
   end
   return terminals[#terminals] or nil
end

local function get_type(type)
   return vim.tbl_filter(function(t)
      return t.type == type
   end, terminals.list)
end

local function get_still_open()
   return vim.tbl_filter(function(t)
      return t.open == true
   end, terminals.list)
end

local function get_last_still_open()
   return get_last(get_still_open())
end

local function get_type_last(type)
   return get_last(get_type(type))
end

local create_term_window = function(type)
   util.execute_type_cmd(type, terminals)

   vim.wo.relativenumber = false
   vim.wo.number = false

   return a.nvim_get_current_win()
end

local create_term = function(type)
   local win = create_term_window(type)
   local buf = a.nvim_create_buf(false, true)

   a.nvim_buf_set_option(buf, "filetype", "terminal")
   a.nvim_buf_set_option(buf, "buflisted", false)
   a.nvim_win_set_buf(win, buf)

   local job_id = vim.fn.termopen(vim.o.shell)
   local term = { win = win, buf = buf, open = true, type = type, job_id = job_id }

   table.insert(terminals.list, term)
   vim.cmd "startinsert"

   return term
end

local ensure_and_send = function(cmd, type)
   terminals = util.verify_terminals(terminals)
   local term = type and get_type_last(type) or get_last_still_open() or nvterm.new "vertical"

   if not term then
      term = nvterm.new "horizontal"
   end

   a.nvim_chan_send(term.job_id, cmd .. "\n")
end

local call_and_restore = function(fn, opts)
   local current_win = a.nvim_get_current_win()
   local mode = a.nvim_get_mode().mode == "i" and "startinsert" or "stopinsert"

   fn(unpack(opts))
   a.nvim_set_current_win(current_win)

   vim.cmd(mode)
end

nvterm.send = function(cmd, type)
   if not cmd then
      return
   end

   call_and_restore(ensure_and_send, { cmd, type })
end

nvterm.hide_term = function(term)
   term.open = false
   a.nvim_win_close(term.win, false)
end

nvterm.show_term = function(term)
   term.open = true
   term.win = create_term_window(term.type)
   a.nvim_win_set_buf(term.win, term.buf)

   vim.cmd "startinsert"
end

nvterm.hide = function(type)
   local term = type and get_type_last(type) or get_last()
   nvterm.hide_term(term)
end

nvterm.show = function(type)
   local term = type and get_type_last(type) or terminals.last
   nvterm.show_term(term)
end

nvterm.new = function(type)
   local term = create_term(type)
   return term
end

nvterm.toggle = function(type)
   terminals = util.verify_terminals(terminals)
   local term = get_type_last(type)

   if not term then
      term = nvterm.new(type)
   elseif term.open then
      nvterm.hide_term(term)
   else
      nvterm.show_term(term)
   end
end

nvterm.init = function(term_config)
   terminals = term_config
end

return nvterm
