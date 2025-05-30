-- disable netrw as we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- default to block cursor
vim.opt.guicursor = ""

-- enable 24-bit colour
vim.opt.termguicolors = true
-- vim.cmd.colorscheme("rose-pine")



-- line numbers
vim.wo.nu = true
vim.wo.relativenumber = true

-- tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- hilight search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- leave 8 lines margin when scrolling
vim.opt.scrolloff = 8

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

-- python3 executable
vim.g.python3_host_prog="/usr/bin/python3"

-- vim.opt.ttimeoutlen = 50 -- Reduce key code delay
-- vim.opt.timeoutlen = 300 -- Reduce mapping delay
