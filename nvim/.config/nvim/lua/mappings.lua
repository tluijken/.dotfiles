function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

nmap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nmap("<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nmap("<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
nmap("<leader>fd", "<cmd>lua require('telescope.builtin').file_browser()<cr>")
nmap("<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")



-- Move to previous/next
nmap("<A-,>", ":BufferLineCyclePrev<CR>")
nmap("<A-.>", ":BufferLineCycleNext<CR>")

-- Re-order to previous/next
nmap("<A-<>", ":BufferLineMovePrev<CR>")
nmap("<A->>", ":BufferLineMoveNext<CR>")
-- Goto buffer in position...
nmap("<A-1>", ":BufferLineGoToBuffer  1<CR>")
nmap("<A-2>", ":BufferLineGoToBuffer  2<CR>")
nmap("<A-3>", ":BufferLineGoToBuffer  3<CR>")
nmap("<A-4>", ":BufferLineGoToBuffer  4<CR>")
nmap("<A-5>", ":BufferLineGoToBuffer  5<CR>")
nmap("<A-6>", ":BufferLineGoToBuffer  6<CR>")
nmap("<A-7>", ":BufferLineGoToBuffer  7<CR>")
nmap("<A-8>", ":BufferLineGoToBuffer  8<CR>")
nmap("<A-9>", ":BufferLineGoToBuffer  9<CR>")
-- Pin/unpin buffer
nmap("<A-p>", ":BufferPin<CR>")
-- Close buffer
nmap("<A-c>", ":BufferClose<CR>")
-- Magic buffer-picking mode
nmap("<A-s>", ":BufferPick<CR>")


-- nvim tree
nmap("<C-n>", ":NvimTreeToggle<CR>")
nmap("<leader>r", "NvimTreeRefresh<CR>")
nmap("<leader>t", ":NvimTreeFocus<CR>")
nmap("<leader>f", ":NvimTreeFindFile<CR>")

vim.opt.splitbelow = splitright

-- Remap splits navigation to just CTRL + hjkl
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

-- Make adjusing split sizes a bit more friendly
nmap("<C-Left>", ":vertical resize +3<CR>")
nmap("<C-Right>", ":vertical resize -3<CR>")
nmap("<C-Up>", ":resize +3<CR>")
nmap("<C-Down>", ":resize -3<CR>")

-- Change 2 split windows from vert to horiz or horiz to vert
nmap("<Leader>th", "<C-w>t<C-w>H")
nmap("<Leader>tk", "<C-w>t<C-w>K")

-- Removes pipes | that act as seperators on splits
vim.opt.fillchars:append "vert\\"

-- code navigation
nmap("<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
nmap("gD", "<cmd>lua vim.lsp.buf.implementation()<CR>")
nmap("<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
nmap("1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
nmap("gr", "<cmd>lua vim.lsp.buf.references()<CR>")
nmap("g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
nmap("gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
nmap("ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
