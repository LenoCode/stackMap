
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


-- opening a new root in NvimTreeView
M.openNewRoot = function (path)
    print("Opening new path"..path)
    local api = require("nvim-tree.api")
    api.tree.close()
    api.tree.toggle({
      path=path,
      find_file = true,
    })
  end


--Open choosed project
M.switchProject = function (index)
  local path = M._stack[index]
  M.openNewRoot(path)
end


-- Get current line index
function getCurrentLine(index)
  local window= vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(window)
  vim.api.nvim_win_close(window,true)
  vim.api.nvim_buf_delete(current_buf,{force = true})
  M.switchProject(index)
end

--GUI FUNCTIONS

--Display all projects
M.displayProjects = function()
  -- Calculate the position for the floating window
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

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

    --Adding Header
    --Adding lines to display

    -- Define a custom highlight group with a specific color
    local highlight_group = "@string"
    vim.api.nvim_buf_set_lines(bufnr,0,0,false,{string.rep(" ",8).."Projects"})

    vim.api.nvim_buf_add_highlight(bufnr, -1, highlight_group, 0, 0, -1)

    for i,project in ipairs(M._stack)do
        local chooseProjectFunction = ":lua getCurrentLine("..i..") <CR>"
        vim.api.nvim_buf_set_option(bufnr,'modifiable',true)
        vim.api.nvim_buf_set_keymap(bufnr,"n",tostring(i),chooseProjectFunction,{noremap = true, silent = true})
        vim.api.nvim_buf_set_lines(bufnr,-1,-1,true,{i.." : "..project})
        vim.api.nvim_buf_set_option(bufnr,'modifiable',false)
    end

    -- Set keymap to close the floating window on 'q'
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', { noremap = true, silent = true })

    local sub_buf = vim.api.nvim_create_buf(false, true)

    -- Set some text in the sub buffer

    -- Get the width and height of the window
    
    -- Open a new window using the sub buffer, within the main window
    local sub_win = vim.api.nvim_open_win(sub_buf, true, {
        relative = 'win',
        row = 20,
        col = 3,
        width = 40,
        height = 1,
        style = 'minimal',
        border = "rounded"
    })
  end

return M
