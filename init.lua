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

-- tabs
vim.o.tabstop = 4      -- Number of spaces that a <Tab> in the file counts for
vim.o.shiftwidth = 4   -- Size of an indent (e.g. with >>)
vim.o.softtabstop = 4  -- Number of spaces that a <Tab> counts for while performing editing operations
-- vim.opt.expandtab = true -- Convert tabs to spaces

-- searching case sensitivity
vim.o.ignorecase = true
vim.o.smartcase = true  -- only case sensitive when caps included

-- misc
vim.cmd('colorscheme unokai')
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.undofile = true
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.scrolloff = 10
vim.o.clipboard = 'unnamedplus'

-- whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }

-- --------------------------- KEYMAPS ----------------------------

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

local function gh(repo) return 'https://github.com/' .. repo end
vim.pack.add({
	gh 'nvim-mini/mini.nvim',
	gh 'lewis6991/gitsigns.nvim'
})

require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.icons').setup()
