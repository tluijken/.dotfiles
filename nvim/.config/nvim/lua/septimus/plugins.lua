local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "Warn" },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Fuzzy finding
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'neovim/nvim-lspconfig',
            'nvim-telescope/telescope-live-grep-args.nvim',
            'someone-stole-my-name/yaml-companion.nvim',
        }
    },

    -- File management
    { "stevearc/oil.nvim" },
    { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- LSP
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'L3MON4D3/LuaSnip' },
    { "williamboman/mason.nvim" },
    { "mfussenegger/nvim-dap" },

    -- Language support
    { "mrcjkb/rustaceanvim" },
    { 'saecki/crates.nvim' },
    { 'normen/vim-pio' },
    { 'hashivim/vim-terraform' },

    -- Editing
    { "kylechui/nvim-surround", version = "*" },
    { "windwp/nvim-autopairs" },
    { 'tpope/vim-fugitive' },

    -- UI
    { "sainnhe/gruvbox-material" },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'NvChad/nvim-colorizer.lua' },
    { "folke/which-key.nvim", dependencies = { "echasnovski/mini.icons" } },
    { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "alexghergh/nvim-tmux-navigation" },
    { "akinsho/toggleterm.nvim", version = '*' },

    -- Focus / writing
    { "folke/twilight.nvim" },
    { "folke/zen-mode.nvim" },
    { "preservim/vim-pencil" },

    -- Copilot
    { "zbirenbaum/copilot.lua" },
}, {
    lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
