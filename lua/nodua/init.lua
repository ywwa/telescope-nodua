local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local func = require("nodua.func")
local M = {}

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
          func.terminal.toggle({
            entry = {
              name = entry.name,
              command = entry.command,
            },
            id = "noduaTerm",
          })
        end)
        return true
      end,
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

M.init = nodua
return M
