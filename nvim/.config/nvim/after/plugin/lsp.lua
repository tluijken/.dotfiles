vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local opts = { buffer = event.buf, remap = false }

        -- Your ESLint workaround
        if client.name == "eslint" then
            vim.cmd.LspStop('eslint')
            return
        end

        -- Keybinds
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end
})

-- 2. Configure Servers (Define custom settings BEFORE enabling)

-- Typescript (ts_ls)
vim.lsp.config.ts_ls = {
    init_options = {
        preferences = {
            disableSuggestions = true,
        },
    },
}

-- Terraform
vim.lsp.config.terraformls = {
    -- 'pattern' is not a valid key for 0.11 config. 
    -- If you meant filetypes, use this:
    filetypes = { "terraform", "tf", "terraform-vars" },
}

-- Dart
vim.lsp.config.dartls = {
    cmd = { "dart", "language-server", "--protocol=lsp" },
}

-- 3. Enable Servers (This replaces .setup({}))
vim.lsp.enable("ts_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("csharp_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("terraformls")
vim.lsp.enable("tflint")
vim.lsp.enable("dartls")
vim.lsp.enable("pyright")
