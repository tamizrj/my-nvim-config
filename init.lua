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
vim.opt.expandtab = true -- Convert tabs to spaces

-- searching case sensitivity
vim.o.ignorecase = true
vim.o.smartcase = true  -- only case sensitive when caps included

-- misc
vim.cmd.colorscheme('catpuccin')
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.undofile = true
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.scrolloff = 10
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = false

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
    gh 'lewis6991/gitsigns.nvim',
})

-- adding basic plugins
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.icons').setup()
require('mini.ai').setup()

-- TREESITTER SETUP (from kickstart)
do
    -- [[ Configure Treesitter ]]
    --  Used to highlight, edit, and navigate code
    --
    --  See `:help nvim-treesitter-intro`

    -- NOTE: You can also specify a branch or a specific commit
    vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

    -- Ensure basic parsers are installed
    local parsers = { 'bash', 'c', 'cpp', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
    require('nvim-treesitter').install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
    end

    local available_parsers = require('nvim-treesitter').get_available()
    vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
    })
end


-- -- LSP & MASON

vim.pack.add({
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'neovim/nvim-lspconfig'
})

-- Initialize Mason (creates the UI and paths)
require('mason').setup()

-- 1. Prepend Mason's local path to Neovim's internal environment PATH.
-- This guarantees Neovim can execute any binaries Mason downloads.
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not string.find(vim.env.PATH, mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- 2. Automatically bootstrap tree-sitter-cli via Mason if missing
local registry = require("mason-registry")
if vim.fn.executable("tree-sitter") == 0 then
    -- Check if the registry is ready, then trigger the install
    registry.refresh(function()
        local p = registry.get_package("tree-sitter-cli")
        if not p:is_installed() then
            vim.notify("Bootstrapping tree-sitter-cli via Mason...", vim.log.levels.INFO)
            p:install():once("closed", function()
                vim.notify("tree-sitter-cli installed successfully!", vim.log.levels.INFO)
            end)
        end
    end)
end

-- Initialize the glue layer
require('mason-lspconfig').setup({
    -- Automatically tell Mason to install these if they are missing
    ensure_installed = { 'lua_ls', 'pyright', 'clangd' }
})

-- Intercept Neovim's startup using nvim-lspconfig
local lspconfig = require('lspconfig')

-- Now, instead of vim.lsp.enable(), you configure servers through lspconfig.
-- It automatically knows to look inside Mason's secret paths!
-- vim.lsp.config.setup({})
-- lspconfig.pyright.setup({})
-- lspconfig.clangd.setup({})

