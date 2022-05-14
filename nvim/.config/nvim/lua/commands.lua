local format_group = vim.api.nvim_create_augroup("fmt", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.cmd[[
            autocmd!
            autocmd BufWritePre * undojoin | Neoformat
        ]]
    end,
    group = format_group,
})
