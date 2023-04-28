if isModuleAvailable('nvim-surround') == false then
  print('nvim-surround not available')
  return
end
require("nvim-surround").setup({
  -- Configuration here, or leave empty to use defaults
})
