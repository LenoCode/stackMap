local M_custom = require("config.custom-functions")

local M = {}

--In memory stack for holding projects root
M._stack = {}

--Read all project stored
M.init = function ()
  local storagePath = "/home/leno/.cache/nvim/projectstack.txt"
  local file = assert(io.open(storagePath,"r"))
  if file then
    for line in file:lines()do
      table.insert(M._stack,line)
    end
  end
end
--Open choosed project
M.switchProject = function (index)
  local path = M._stack[index]
  M_custom.openNewRoot(path)
end


--GUI FUNCTIONS

--Display all projects
M.displayProjects = function()
  -- Calculate the position for the floating window
local width = vim.fn.winwidth(0)
local height = vim.fn.winheight(0)

local col = math.floor((width - 40) / 2)
local row = math.floor((height - 10) / 2)

-- Create the contents for the floating window
local content = {
    "This is a small floating window",
    "Press 'q' to close",
    "Line 1",
    "Line 2",
    "Line 3",
}

-- Create the floating window
local opts = {
    relative = 'editor',
    width = 40,
    height = 10,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
}

local winid = vim.api.nvim_open_win(0, true, opts)

-- Set the content in the floating window
vim.api.nvim_buf_set_lines(0, 0, -1, false, content)

-- Set keymap to close the floating window on 'q'
vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

end

return M
