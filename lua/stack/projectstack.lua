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
    vim.api.nvim_buf_set_lines(bufnr,0,0,false,{string.rep(" ",6).."Projects"})

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
    vim.api.nvim_buf_set_lines(sub_buf, 0, -1, false, {"Sub buffer content"})

    -- Open a new window using the sub buffer, within the main window
    local sub_win = vim.api.nvim_open_win(sub_buf, true, {
        relative = 'editor',
        row = 1,
        col = 1,
        width = 20,
        height = 3,
        style = 'minimal',
        border = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    })
    


  end

return M
