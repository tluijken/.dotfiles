-- Function to get the namespace based on the current file path
local function get_namespace()
  local file_path = vim.fn.expand('%:p')
  local project_root = vim.fn.getcwd()   -- You can replace this with your project root if it's different
  local namespace_path = file_path:sub(#project_root + 2, - #(vim.fn.expand('%:t')) - 2)
  local namespace = namespace_path:gsub("/", ".")
  return namespace
end

-- Function to get the class name based on the current file name
local function get_class_name()
  return vim.fn.expand('%:t:r')
end

-- Function to check if a file is empty
local function is_file_empty(file_name)
  local file = io.open(file_name, "r")
  if not file then return false end
  local content = file:read("*all")
  file:close()
  return content == ""
end

-- Function to create and load the C# template
function load_cs_template()
  local file_name = vim.fn.expand('%:p')
  if is_file_empty(file_name) then
    local namespace = get_namespace()
    local class_name = get_class_name()

    local template = "using System;\n\n" ..
        "namespace " .. namespace .. ";\n\n" ..
        "public class " .. class_name .. "\n" ..
        "{\n" ..
        "}\n"

    vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(template, "\n"))
    vim.cmd("normal! 6G")
    vim.cmd("normal! o")
    vim.cmd("startinsert!")
    vim.cmd("normal! i" .. string.rep(" ", vim.bo.shiftwidth + 1))     -- Insert the proper number of spaces
  end
end

-- Autocommand for new or empty C# files
vim.cmd("au BufRead,BufNewFile *.cs lua load_cs_template()")
