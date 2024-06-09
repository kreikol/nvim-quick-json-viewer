local M = {}

local info = require('nvim-quick-json-viewer.globals')
local proto = require('nvim-quick-json-viewer.prototype')

M.setup = function()
  -- Commando de usuario

  vim.api.nvim_create_user_command('JsonViewer', function(opts)
      local init_mark = vim.api.nvim_buf_get_mark(0, "<")
      local end_mark = vim.api.nvim_buf_get_mark(0, ">")
      -- print('init: ' .. vim.inspect(init_mark))
      -- print('end : ' .. vim.inspect(end_mark))

      local get_column = function(mark)
        if (mark[2] == 2147483647) then -- TODO Cuando es el final de la línea devuelve el max number
          local line = vim.api.nvim_buf_get_lines(0, mark[1] - 1, mark[1], false)[1]
          return string.len(line)
        end
        return mark[2]
      end

      -- print('column init: ' .. get_column(init_mark))
      -- print('column end : ' .. get_column(end_mark))

      local selected_table = vim.api.nvim_buf_get_text(0, init_mark[1] - 1, get_column(init_mark), end_mark[1] - 1,
        get_column(end_mark) + 1,
        {})
      -- print('table: ' .. vim.inspect(selected_table))

      local selected = ''
      for k, v in pairs(selected_table) do
        selected = selected .. v
      end
      -- print('selected>>>>> ' .. vim.inspect(selected))

      local json = proto.prettier_lines(selected)
      proto.open_float_win(json)
    end,

    {
      range = true,
    })
end

return M
