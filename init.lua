-- print("Hello from the new config!")

vim.g.mapleader = ' '

-- require('vim._core.ui2').enable() -- maybe later

-- --------------------------- OPTIONS ----------------------------
-- linenos
vim.o.number = true
vim.o.relativenumber = true

-- splits
vim.o.splitright = true
vim.o.splitbelow = true

-- misc
vim.cmd('colorscheme unokai')
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.undofile = true

-- whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- --------------------------- KEYMAPS ----------------------------

-- copy/paste to clipboard
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- ------------------------ AUTOCOMMANDS ----------------------------

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- -------------------------- PLUGINS ------------------------------

vim.pack.add({
	"https://github.com/nvim-mini/mini.nvim"
})

require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.icons').setup()
