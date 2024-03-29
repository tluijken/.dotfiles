if isModuleAvailable('lspconfig') == false then
    print('lspconfig is not available')
    return
end
require 'lspconfig'.terraformls.setup({})
require 'lspconfig'.tflint.setup({})

vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])
-- vim.keymap("n", "<leader>ti", ":!terraform init<CR>", opts)
-- vim.keymap("n", "<leader>tv", ":!terraform validate<CR>", opts)
-- vim.keymap("n", "<leader>tp", ":!terraform plan<CR>", opts)
-- vim.keymap("n", "<leader>taa", ":!terraform apply -auto-approve<CR>", opts)
