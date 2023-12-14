local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local json = require("nodua.json")

local function isNodeProject()
	local file = io.open(vim.fn.getcwd() .. "/package.json", "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end

local function parsePackageJson()
	local file = io.open(vim.fn.getcwd() .. "/package.json", "r")
	local content = file:read("*a")
	file:close()

	local packageData = json.decode(content)

	if packageData and packageData.scripts then
		-- return packageData.scripts
		local list = {}
		for name, cmd in pairs(packageData.scripts) do
			table.insert(list, { name = name, command = cmd })
		end
		return list
	else
		return nil
	end
end

local displayer = entry_display.create({
	separator = " => ",
	items = {
		{ width = 50 },
		{ remaining = true },
	},
})

local make_display = function(entry)
	return displayer({
		entry.name .. " => " .. entry.command,
	})
end

local spawnTerm = function(entry)
	require("nvchad.term").new({
		pos = "sp",
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
				results = parsePackageJson(),
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
					local command = action_state.get_selected_entry()
					actions.close(bufnr)
					spawnTerm(command)
				end)
        return true
			end,
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

M.showNodua = nodua

return M
