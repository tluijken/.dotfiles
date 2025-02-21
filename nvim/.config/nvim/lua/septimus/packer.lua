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
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope-live-grep-args.nvim' }
        }
    }
    use("stevearc/oil.nvim")
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('norcalli/nvim-colorizer.lua')
    use('tpope/vim-fugitive')
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage the language servers from neovim
            -- {'williamboman/mason.nvim'},
            -- {'williamboman/mason-lspconfig.nvim'},

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
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
    use { "folke/which-key.nvim", requires = "echasnovski/mini.icons" }
    use { "folke/twilight.nvim" }
    use { "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons", }
    use { "alexghergh/nvim-tmux-navigation" }
    use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }
    use { "williamboman/mason.nvim" }
    use { "akinsho/toggleterm.nvim", tag = '*' }
    if packer_bootstrap then
        require('packer').sync()
    end
end)
