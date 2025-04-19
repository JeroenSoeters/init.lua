vim.g.mapleader = " "

-- toggle nvim-tree
vim.keymap.set("n", "<leader>nn", vim.cmd.NvimTreeToggle)

-- better split switching
vim.keymap.set("n", "<C-h>", "<C-W>h")
vim.keymap.set("n", "<C-j>", "<C-W>j")
vim.keymap.set("n", "<C-k>", "<C-W>k")
vim.keymap.set("n", "<C-l>", "<C-W>l")

-- fast save
vim.keymap.set("n", "<leader>w", ":w<cr>")

-- switch buffers
vim.keymap.set("n", "<S-h>", ":bprev<cr>")
vim.keymap.set("n", "<S-l>", ":bnext<cr>")

-- move hilighted block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor centered while jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
--vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- don't use Q
vim.keymap.set("n", "Q", "<nop>")

-- switch between projects
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", ":so<cr>")

-- custom mappings for java dev
vim.keymap.set('n', '<Leader>tm', ':JavaTestRunCurrentMethod<cr>', { noremap = true, silent = true, desc = 'Run test method' })
vim.keymap.set('n', '<Leader>tc', ':JavaTestRunCurrentClass<cr>', { noremap = true, silent = true, desc = 'Run test class' })
vim.keymap.set('n', '<Leader>dm', ':JavaTestDebugCurrentMethod<cr>', { noremap = true, silent = true, desc = 'Debug test method' })
vim.keymap.set('n', '<Leader>dc', ':JavaTestDebugCurrentClass<cr>', { noremap = true, silent = true, desc = 'Debug test class' })
vim.keymap.set('n', '<Leader>tr', ':JavaTestViewLastReport<cr>', { noremap = true, desc = 'View last test report' })
vim.keymap.set('n', '<Leader>b', ':DapToggleBreakpoint<cr>', { noremap = true, desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<C-o>', ':DapStepOver<cr>', { noremap = true, desc = 'Step over' })
vim.keymap.set('n', '<C-i>', ':DapStepInto<cr>', { noremap = true, desc = 'Step into' })
vim.keymap.set('n', '<Leader>c', ':DapContinue<cr>', { noremap = true, desc = 'Continue' })
vim.api.nvim_set_keymap('v', '<C-e>', '<Cmd>lua require("dapui").eval()<CR>', {noremap = true})
