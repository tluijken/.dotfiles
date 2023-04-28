if isModuleAvailable('nvim-tmux-navigation') == false then
  print('nvim-tmux-navigation is not available')
  return
end
require 'nvim-tmux-navigation'.setup {
  disable_when_zoomed = true,   -- defaults to false
  keybindings = {
    left = "<C-h>",
    down = "<C-j>",
    up = "<C-k>",
    right = "<C-l>",
    last_active = "<C-\\>",
    next = "<C-Space>",
  }
}
