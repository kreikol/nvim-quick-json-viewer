local J = {}

J.to_prettier = function(raw)
  local formatted = ''
  vim.system({ "jq" }, { stdin = raw }, function(obj)
    -- print('resultado....')
    -- print('>>> ' .. obj.stdout)
    formatted = obj.stdout
  end):wait()
  return formatted
end

J.prettier_lines = function(raw)
  local formatted = J.to_prettier(raw)
  -- print('PRETTIER >>> ' .. formatted)
  local lines = J.json_to_table_lines(formatted)
  -- print(lines)
  return lines
end


-- Parsea el json a una tabla de líneas de texto, teniendo una entrada por cada línea (split por \r\n)
J.json_to_table_lines = function(json)
  local l = {}
  for s in json:gmatch("[^\r\n]+") do
    table.insert(l, s)
  end
  return l
end

local test = ' {"name": "Miriam", "apellido": "Ruiz", "edad": 37, "tested": false}'

-- abrir nueva ventana
J.open_float_win = function(text)
  local win_config = vim.api.nvim_win_get_config(0)
  local cfg = {
    title = 'Json Pretty Viewer',
    relative = 'editor',
    row = 6,
    col = 12,
    width = win_config.width - 50,
    height = win_config.height - 10,
    border = "rounded",
  }


  vim.api.nvim_command('botright vnew')
  local buffer_number = vim.api.nvim_get_current_buf()
  vim.api.nvim_command('close')
  vim.api.nvim_open_win(buffer_number, true, cfg)
  vim.api.nvim_set_option_value("filetype", 'json', {
    buf = buffer_number
  })
  vim.api.nvim_buf_set_lines(buffer_number, -1, -1, false, text)
end

return J
