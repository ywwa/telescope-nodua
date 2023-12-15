local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local getScripts = function()
  local file = io.open(vim.fn.getcwd() .. "/package.json", "r")
  if not file then
    return {}
  end

  local jsonContent = file:read("*a")
  file:close()

  local pkgData = vim.json.decode(jsonContent)
  if pkgData and pkgData.scripts then
    local list = {}
    for name, cmd in pairs(pkgData.scripts) do
      table.insert(list, { name = name, command = cmd })
    end
    return list
  end

  return {}
end

local displayer = entry_display.create({
  separator = " ",
  items = {
    { width = 50 },
    { remaining = true },
  },
})
local make_display = function(entry)
  return displayer({ entry.name .. " " .. entry.command })
end

local spawnTerminal = function(entry)
  require("nvchad.term").toggle({
    pos = "sp",
    id = "htoggleterm",
    size = 0.3,
    cmd = "npm run " .. entry.name,
  })
end

local nodua = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Node Scripts",
      finder = finders.new_table({
        results = getScripts(),
        entry_maker = function(entry)
          return {
            ordinal = entry.name .. entry.command,
            display = make_display,
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
          spawnTerminal(entry)
        end)
        return true
      end,
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

M.init = nodua
return M
