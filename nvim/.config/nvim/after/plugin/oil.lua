if isModuleAvailable('oil') == false then
    print('oil not available')
    return
end
require("oil").setup()

vim.keymap.set("n", "<leader>v", function()
  vim.cmd("vsplit | wincmd l")
  require("oil").open()
end)
