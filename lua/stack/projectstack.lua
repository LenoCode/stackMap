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
    local listOfWindows = vim.api.nvim_list_wins()

    local width = vim.fn.winwidth(0)
    local height = vim.fn.winheight(0)

    local col = math.floor((width - 40) / 2)
    local row = math.floor((height - 20) / 2)


    -- Create the floating window
    local opts = {
        relative = 'editor',
        width = 40,
        height = 20,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
    }
    local bufnr = vim.api.nvim_create_buf(false, true)
    local winid = vim.api.nvim_open_win(bufnr,true, opts)
        -- Define button mappings


    local testFunction = function ()
      local current_line = vim.api.nvim_get_current_line()

      print(current_line)
    end


    vim.api.nvim_buf_set_keymap(bufnr,"n","<CR>",":lua testFunction",{noremap = true, silent = true})

    for _, win in ipairs(listOfWindows)do
        local buffer= vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buffer)

        vim.api.nvim_buf_set_option(bufnr,'modifiable',true)
        vim.api.nvim_buf_set_lines(bufnr,-1,-1,true,{"buffer name : "..bufname})
        vim.api.nvim_buf_set_option(bufnr,'modifiable',false)
    end

    -- Set the content in the floating window

    -- Set keymap to close the floating window on 'q'
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

  end

return M
