local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local func = require("nodua.func")
local M = {}

local spawnTerminal = function(entry)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd("sp")
  local win = vim.api.nvim_get_current_win()

  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].signcolumn = "no"
  vim.bo[buf].buflisted = false

  local size = vim.o["lines"] * 0.35
  vim.api.nvim_win_set_height(0, math.floor(size))
  vim.api.nvim_win_set_buf(win, buf)
  local shell = vim.o.shell
  local cmd = {
    shell,
    "-c",
    "npm run " .. entry.command,
  }
  vim.fn.termopen(cmd)
end

local nodua = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Node Scripts",
      finder = finders.new_table({
        results = func.getScripts(),
        entry_maker = function(entry)
          return {
            ordinal = entry.name .. entry.command,
            display = func.make_display,
            value = entry.command,

            name = entry.name,
            command = entry.command,
          }
        end,
      }),
      attach_mappings = function(bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(bufnr)
          func.terminal.toggle({ entry = entry, id = "noduaTerm" })
        end)
        return true
      end,
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

M.init = nodua
return M
