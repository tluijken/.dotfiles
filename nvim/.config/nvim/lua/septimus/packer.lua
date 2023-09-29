local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-live-grep-args.nvim' }
        }
    }
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('tpope/vim-fugitive')
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            {
                "williamboman/mason.nvim",
                run = ":MasonUpdate" -- :MasonUpdate updates registry contents
            },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    })
    use {
        'saecki/crates.nvim',
    }
    use { "simrat39/rust-tools.nvim" }
    use { "mfussenegger/nvim-dap" }
    use { "terrortylor/nvim-comment" }
    use { 'normen/vim-pio' }
    use { 'hashivim/vim-terraform' }
    use { "rebelot/heirline.nvim" }
    use { "sainnhe/gruvbox-material" }
    use { "zbirenbaum/copilot.lua" }
    use { "windwp/nvim-autopairs" }
    use { "folke/which-key.nvim" }
    use { "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons", }
    use { "alexghergh/nvim-tmux-navigation" }
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' }, tag = 'nightly' }
    use { "akinsho/toggleterm.nvim", tag = '*' }
    if packer_bootstrap then
        require('packer').sync()
    end
end)
