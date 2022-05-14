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
        run = ":TSUpdate",
    }

    -- Collection of common configurations for the Nvim LSP client
    use 'neovim/nvim-lspconfig'

    -- Completion framework
    use {
        'hrsh7th/nvim-cmp',
        config = require "plugins.configs.cmp",
    }

    -- LSP completion source for nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp'

    -- Other usefull completion sources
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-buffer'

    -- Snippet engine
    use 'hrsh7th/vim-vsnip'
    use {'neoclide/coc.nvim', branch = 'release'}

    -- RUST 
    use 'simrat39/rust-tools.nvim'
    use 'rust-lang/rust.vim'

    use 'sbdchd/neoformat'

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

    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

