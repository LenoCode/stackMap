return {
  searchFilesAndOpen = function()
    local api = require("nvim-tree.api")
    api.tree.focus()
    api.tree.search_node()
    api.tree.open()
  end,
  --Dependency required nvim-tree.api
  openNewRoot = function (path)
    local api = require("nvim-tree.api")
    api.tree.close()
    api.tree.toggle({
      path=path,
      find_file = true,
    })
  end

}




