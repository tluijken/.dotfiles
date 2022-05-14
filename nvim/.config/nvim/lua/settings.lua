HOME = os.getenv("HOME")

vim.g.mapleader = " "

vim.cmd [[set fcs=eob:\ ]]
vim.cmd [[filetype plugin indent on]]

vim.cmd [[highlight ColorColumn ctermbg=0 guibg=grey]]
vim.cmd [[syntax enable]]
vim.cmd [[filetype plugin indent on]]

local options = {
    exrc = true,
    termguicolors = true,
    fileencoding = "utf-8",
    backup = false,
    swapfile = false,
    hlsearch = false,
    incsearch = true,
    showmode = false,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    scrolloff = 8,
    sidescrolloff = 5,
    smartindent = true,
    signcolumn = "no",
    hidden = true,
    ignorecase = true,
    timeoutlen = 1000,
    shiftround = true,
    smartcase = true,
    splitbelow = true,
    splitright = true,
    number = true,
    relativenumber = true,
    clipboard = "unnamedplus",
    cursorline = true,
    mouse = "nicr",
    mouse = "a",
    cmdheight = 1,
    undodir = "/tmp/.nvimdid",
    undofile = true,
    pumheight = 10,
    laststatus = 3,
    updatetime = 250,
    compatible = false,
    completeopt = "menuone,noinsert,noselect"
}

vim.opt.shortmess:append "c"

for key, value in pairs(options) do
    vim.opt[key] = value
end

vim.g.gruvbox_material_enable_italic_comment = 1
