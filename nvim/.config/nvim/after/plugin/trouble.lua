require("trouble").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
}

vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
)
