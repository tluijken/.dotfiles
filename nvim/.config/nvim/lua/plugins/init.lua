local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
end
vim.cmd [[packadd packer.nvim]]

local ok, packer = pcall(require, "packer")

if not ok then
    return
end

packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "single" }
        end,
        prompt_border = "single",
    },
    git = {
        clone_timeout = 600,
    },
    auto_clean = true,
    compile_on_sync = false,
}

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    
    -- UI
    use {
        "nvim-lualine/lualine.nvim",
        config = require "plugins.configs.lualine",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    }
    use {
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = require "plugins.configs.bufferline",
    }
    -- Syntax
    use {
        "nvim-treesitter/nvim-treesitter",
        config = require "plugins.configs.treesitter",
        run = ":TSUpdate",
    }

    -- Collection of common configurations for the Nvim LSP client
    use {
        "williamboman/nvim-lsp-installer",
        "neovim/nvim-lspconfig",
    }

    use {
        "RRethy/vim-illuminate",
        config = require "plugins.configs.vim-illuminate"
    }

    -- Completion framework
    use {
        'hrsh7th/nvim-cmp',
        config = require "plugins.configs.cmp",
    }
    -- Copilot
    use 'github/copilot.vim'

    -- LSP completion source for nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp'

    -- Other usefull completion sources
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'

    -- Snippet engine
    use 'hrsh7th/vim-vsnip'
    use {'neoclide/coc.nvim', branch = 'release'}

    -- RUST 
    use 'rust-lang/rust.vim'
    use {
        'simrat39/rust-tools.nvim',
        config = require "plugins.configs.rust-tools"
    }

    -- Utilities
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        config = require "plugins.configs.telescope"
    }
    use 'nvim-lua/popup.nvim'
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
        config = require "plugins.configs.nvimtree",
    }
    use {
        "windwp/nvim-autopairs",
        config = require "plugins.configs.autopairs"
    }
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })


    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

