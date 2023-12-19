local M = {}

M.getScripts = function()
  local packageFile = io.open(vim.fn.getcwd() .. "/package.json", "r")
  if not packageFile then
    return {}
  end

  local fileContent = packageFile:read("a")
  packageFile:close()

  local packageData = vim.json.decode(fileContent)
  if packageData and packageData.scripts then
    local sciptList = {}
    for scriptName, scriptCommand in pairs(packageData.scripts) do
      table.insert(sciptList, { name = scriptName, command = scriptCommand })
    end
    return sciptList
  end
  return {}
end

local entry_display = require("telescope.pickers.entry_display")
M.make_display = function(entry)
  local displayer = entry_display.create({
    separator = " ",
    items = { { width = 50 }, { remaining = true } },
  })
  return displayer({
    entry.name .. " " .. entry.command,
  })
end

vim.g.noduaTerms = {}

M.terminal = {
  new = function(opts, existing_buf)
    local buf = existing_buf or vim.api.nvim_create_buf(false, true)
    vim.cmd("sp")
    local win = vim.api.nvim_get_current_win()
    opts.win = win

    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].foldcolumn = "0"
    vim.wo[win].signcolumn = "no"
    vim.bo[buf].buflisted = false

    local size = vim.o.lines * 0.2
    vim.api.nvim_win_set_height(0, math.floor(size))
    vim.api.nvim_win_set_buf(win, buf)

    opts.id = opts.id .. "_" .. opts.entry.name

    local term = vim.g.noduaTerms["noduaTerm_" .. opts.entry.name]

    if not term or not vim.api.nvim_buf_is_valid(term.bufnr) then
      vim.fn.termopen({
        vim.o.shell,
        "-c",
        "npm run " .. opts.entry.name,
      })
    end

    local termList = vim.g.noduaTerms
    termList[tostring(buf)] = opts
    if opts.id then
      opts.bufnr = buf
      termList[opts.id] = opts
    end
    vim.g.noduaTerms = termList
  end,

  toggle = function(opts)
    local term = vim.g.noduaTerms[opts.id .. "_" .. opts.entry.name]
    if term == nil or not vim.api.nvim_buf_is_valid(term.bufnr) then
      M.terminal.new(opts, nil)
    elseif vim.fn.bufwinid(term.bufnr) == -1 then
      M.terminal.new(opts, term.bufnr)
    else
      vim.api.nvim_win_close(term.win, true)
    end
  end,
}

return M
