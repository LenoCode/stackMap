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
local bufnr = vim.api.nvim_create_buf(false, true)
local winid = vim.api.nvim_open_win(bufnr,true, opts)
    -- Define button mappings
local buttons = {
    { text = "Button 1", action = function() print("Button 1 clicked!") end },
    { text = "Button 2", action = function() print("Button 2 clicked!") end },
}

local testFunction = function ()
  local current_line = vim.api.nvim_get_current_line()
  print(current_line)
end


vim.api.nvim_buf_set_keymap(bufnr,"n","<CR>",":lua print(vim.api.nvim_get_current_line())<CR> ",{noremap = true, silent = true})

vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  -- Set buffer content (buttons)
    for i, button in ipairs(buttons) do
        vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, true, { button.text })
        vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
    end

-- Set the content in the floating window

-- Set keymap to close the floating window on 'q'
vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

end

return M
