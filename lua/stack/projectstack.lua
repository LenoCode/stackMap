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


-- Get current line index
function getCurrentLine()
  local window= vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)
  print(cursor[1])
end

--GUI FUNCTIONS

--Display all projects
M.displayProjects = function()
  -- Calculate the position for the floating window
    local listOfWindows = vim.api.nvim_list_wins()

    local width = vim.fn.winwidth(0)
    local height = vim.fn.winheight(0)

    local col = math.floor((width - 40) / 2)
    local row = math.floor((height - 20) / 2)


    -- Create the floating window
    local opts = {
        relative = 'editor',
        width = 80,
        height = 20,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
    }
    local bufnr = vim.api.nvim_create_buf(false, true)
    local winid = vim.api.nvim_open_win(bufnr,true, opts)
        -- Define button mappings

    vim.api.nvim_buf_set_keymap(bufnr,"n","<CR>",":lua getCurrentLine() <CR>",{noremap = true, silent = true})

    for _,project in ipairs(M._stack)do
        vim.api.nvim_buf_set_option(bufnr,'modifiable',true)
        vim.api.nvim_buf_set_lines(bufnr,-1,-1,true,{"buffer name : "..project})
        vim.api.nvim_buf_set_option(bufnr,'modifiable',false)
    end

    -- Set the content in the floating window

    -- Set keymap to close the floating window on 'q'
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

  end

return M
