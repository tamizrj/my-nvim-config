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
vim.cmd.colorscheme('unokai')
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
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {desc = 'Clear highlights'})
vim.keymap.set('n', '<leader>cr', '<cmd>%s/\r//g<CR>', {desc = '[C]lear \r characters'})

-- ------------------------ AUTOCOMMANDS ----------------------------

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

-- -------------------------- PLUGINS ------------------------------

local function gh(repo) return 'https://github.com/' .. repo end

vim.api.nvim_create_user_command('PackUpdate', function()
    vim.pack.update({})
end, {})

vim.api.nvim_create_user_command('PackSync', function()
    vim.pack.update(nil, { target = 'lockfile' })
end, {})

vim.api.nvim_create_user_command('PackDelete', function()

    print("bro just use vim.pack.del()")
end, {})

vim.pack.add({
    gh 'nvim-mini/mini.nvim',
    gh 'lewis6991/gitsigns.nvim',
    { src = gh 'saghen/blink.cmp', version = vim.version.range('^1') }
})

require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.icons').setup()
require('mini.ai').setup()

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },

    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
    window = {
        width = "auto",
        delay = 0
    }
})

require('blink.cmp').setup({
    keymap = { preset = 'super-tab' },
    signature = { enabled = true },
})

-- ---------------------- MASON & LSP ------------------------

vim.pack.add({
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'neovim/nvim-lspconfig',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
})

require('mason').setup()

-- use to default install certain tools
-- mason-tool-installer allows tools that are not servers
-- in ensure_installed e.g. TS, formatters
require('mason-tool-installer').setup({
    ensure_installed = {
        'tree-sitter-cli',
        'lua_ls',
    },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'require'
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

require('mason-lspconfig').setup({
  automatic_enable = true, -- runs vim.lsp.enable()
})


-- LSP Keymaps
-- Create an augroup to ensure this doesn't get duplicated if you reload your config
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
    callback = function(event)
        -- 'event.buf' is the internal ID of the file you just opened.

        -- 1. Create a helper function to easily map keys specifically to THIS buffer.
        -- Passing `{ buffer = event.buf }` is the magic that prevents global pollution.
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- 2. Define your keymaps
        map('K', vim.lsp.buf.hover, 'Hover documentation')
        map('grd', vim.lsp.buf.definition, '[g]o to [d]efinition')
        map('grd', vim.lsp.buf.declaration, '[g]o to [D]eclaration')
        map('grr', vim.lsp.buf.references, '[g]o to [r]eferences')
        map('grn', vim.lsp.buf.rename, '[r]e[n]ame symbol')
        map('gra', vim.lsp.buf.code_action, 'code [a]ction')
        miniclue.ensure_buf_triggers()

        -- -- Enable Native Autocompletion
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client and client:supports_method('textDocument/completion') then
        --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
        -- end
    end,
})


-- Inline Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
  underline = true,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = '●',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})

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
