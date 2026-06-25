-- print("Hello from the new config!")
vim.g.mapleader = ' '

-- require('vim._core.ui2').enable() -- maybe later
require('config.options')
require('config.keymaps')
require('config.autocmds')

require('plugins')
