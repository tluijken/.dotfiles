if not pcall(require, 'nvim-treesitter.configs') then return end
require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "cpp",
        "terraform",
        "hcl",
        "javascript",
        "typescript",
        "go",
        "java",
        "c",
        "lua",
        "rust",
        "c_sharp"
    },

    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    refactor = {
        highlight_definitions = {
            enable = true,
            clear_on_cursor_move = true,
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gnd",
                list_definitions = "gnD",
                list_definitions_toc = "gO",
                goto_next_usage = "<a-*>",
                goto_previous_usage = "<a-#>",
            },
        },
    },
}
