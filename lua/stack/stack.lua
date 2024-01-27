local M = {}

P = function(v)
	print(vim.inspect(v))
end


local find_existing = function (lhs,current_maps)

  for _, value in ipairs(current_maps) do
    print(value.lhs)
    if lhs == value.lhs then
      return value
    end
  end
  return nil
end

--Function for finding_mapping_that_overlap

--MAIN STACK OBJECT FOR HOLDING ALL MAPS
M._stack = {}

M.push = function (name,mode,new_maps)
  local current= vim.api.nvim_get_keymap(mode)
  local existing_maps_storage = {}

  for lhs, rhs in pairs(new_maps) do
      local existing = find_existing(lhs,current)
      if existing then
        existing_maps_storage[lhs] = existing
      end
  end

  for lhs,rhs in pairs(new_maps) do
      vim.keymap.set(mode,lhs,rhs)
  end

  M._stack[name][mode] = nil
end

return M;
