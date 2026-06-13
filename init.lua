-- print("Hello from the new config!")
vim.g.mapleader = " "

require('vim._core.ui2').enable()
require('config.options')
require('config.keymaps')
require('config.autocmds')
