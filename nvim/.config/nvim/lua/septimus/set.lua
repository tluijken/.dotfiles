local opt = vim.opt
local g = vim.g

opt.nu = true
opt.laststatus = 3
opt.showmode = false
opt.relativenumber = true
-- highlights the current line
opt.cursorline = false

-- Indenting
opt.expandtab = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.softtabstop = 4

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

-- opt.colorcolumn = "80"
g.mapleader = " "
opt.clipboard = 'unnamedplus'
opt.fillchars = { eob = " " }
opt.spelllang = { "en", "nl" }
opt.spell = true
