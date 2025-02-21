if isModuleAvailable('which-key') == false then
  print('which-key is not available')
  return
end
-- local wk = require("which-key")
-- wk.register({
--   f = {
--     name = "find",                                            -- optional group name
--     f = { "<cmd>Telescope find_files<cr>", "Find File" },     -- create a binding with label
--     g = "Grep",                                               -- just a label. don't create any mapping
--     b = "Buffers",                                            -- same as above
--   },
-- }, { prefix = "<leader>" })
