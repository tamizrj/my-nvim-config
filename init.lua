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

-- tabs (overwritten by .editorconfig if in ~)
vim.o.tabstop = 4        -- Number of spaces that a <Tab> in the file counts for
vim.o.shiftwidth = 4     -- Size of an indent (e.g. with >>)
vim.o.softtabstop = 4    -- Number of spaces that a <Tab> counts for while performing editing operations
vim.opt.expandtab = true -- Convert tabs to spaces

-- searching case sensitivity
vim.o.ignorecase = true
vim.o.smartcase = true -- only case sensitive when caps included

-- misc
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.undofile = true
vim.o.confirm = true
vim.o.termguicolors = true
vim.o.scrolloff = 10
vim.o.clipboard = 'unnamedplus'
vim.o.wrap = false
vim.o.cursorline = true
vim.o.showmode = false
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- -------------------------- KEYMAPS ----------------------------

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'clear highlights' })
vim.keymap.set('n', '<leader>cr', '<cmd>%s/\\r//g<CR>', { desc = 'delete [c]arraige [r]eturn' })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = '[w]rite buffer' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'exit terminal mode' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'expand [e]rror' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = '[q]uickfix list' })

vim.keymap.set('n', '<leader>ts', function()
  vim.cmd.split()
  vim.cmd.term()
  vim.api.nvim_win_set_height(0, 15)
end, { desc = '[t]erm [s]plit' })

vim.keymap.set('n', '<leader>tv', function()
  vim.cmd.vsplit()
  vim.cmd.term()
end, { desc = '[t]erminal [v]split' })

-- vim.keymap.set('n', '<CR>', function()
--   local jumps = vim.v.count1
--   vim.cmd('normal! v')
--   require('vim.treesitter._select').select_parent(jumps)
-- end, { desc = "init incremental selection" })

vim.keymap.set('x', '<CR>', function()
  require('vim.treesitter._select').select_parent(vim.v.count1)
end, { desc = "expand selection" })

vim.keymap.set('x', '<BS>', function()
  require('vim.treesitter._select').select_child(vim.v.count1)
end, { desc = "shrink selection" })

vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'move to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'move to right window' })

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'open Oil at cwd' })

-- ------------------------ AUTOCOMMANDS ----------------------------

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- smart relative number lines
-- from: https://github.com/sitiom/nvim-numbertoggle/blob/main/plugin/numbertoggle.lua
local numbertoggle_group = vim.api.nvim_create_augroup("numbertoggle", {})

-- toggle on rnu
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle_group,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

-- toggle off rnu
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
  pattern = "*",
  group = numbertoggle_group,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
        vim.cmd "redraw"
      end
    end
  end,
})

-- -------------------------- PLUGINS ------------------------------

local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

vim.api.nvim_create_user_command('PackSync', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, {})

vim.api.nvim_create_user_command('PackDelete', function(opts)
    -- opts.fargs[1] captures the first whitespace-separated argument
    local package_name = opts.fargs[1]

    -- vim.pack.del expects a table of strings or a single string
    vim.pack.del({ package_name })
  end,
  {
    nargs = 1,
    desc = 'Deletes a package from disk and lockfile',
  }
)

vim.api.nvim_create_user_command("PackClean", function()
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then
      vim.pack.del({ p.spec.name })
      print("Removed inactive plugin: " .. p.spec.name)
    end
  end
end, {})

vim.pack.add({
  gh 'nvim-mini/mini.nvim',
  { src = gh 'saghen/blink.cmp', version = vim.version.range('^1') },
  gh 'navarasu/onedark.nvim',
  gh 'stevearc/conform.nvim',
  gh 'NMAC427/guess-indent.nvim',
  gh 'j-hui/fidget.nvim',
  gh 'lukas-reineke/indent-blankline.nvim',
  gh 'stevearc/oil.nvim',
  gh 'refractalize/oil-git-status.nvim',
  gh 'JezerM/oil-lsp-diagnostics.nvim'
})

require('oil').setup({
  win_options = {
    signcolumn = "yes:2",
  },
})
require('oil-git-status').setup({})
require('oil-lsp-diagnostics').setup({})
require('ibl').setup({
  scope = {
    enabled = true,
    show_start = false,
    show_end = false
  }
})
require('fidget').setup({})
require('guess-indent').setup({})
require('onedark').setup({
  style = 'warmer',
})
require('onedark').load()

local gen_hi = require('mini.extra').gen_highlighter
require('mini.hipatterns').setup({
  highlighters = {
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    fixme     = gen_hi.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
    hack      = gen_hi.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
    todo      = gen_hi.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
    note      = gen_hi.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
  }
})

-- Mini Setup
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.icons').setup()
require('mini.statusline').setup()
require('mini.git').setup()
require('mini.diff').setup({
  view = {
    style = 'sign',
  }
})

require('mini.sessions').setup()
vim.api.nvim_create_user_command('SeshCreate', function(opts)
  local session_name = opts.fargs[1]
  MiniSessions.write(session_name)
end, { nargs = 1, desc = 'Make session with mini.sessions' })

vim.api.nvim_create_user_command('SeshDel', function(opts)
  local session_name = opts.fargs[1]
  MiniSessions.delete(session_name)
end, { nargs = 1, desc = 'Delete session with mini.sessions' })

require('mini.starter').setup({
  -- default, excluding '-' (bound to :Oil)
  query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_.',
  silent = true,
  header = [[
                                             
      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
]],
  footer = 'tamizrj'
})

local gen_spec = require('mini.ai').gen_spec
local gen_ai_spec = require('mini.extra').gen_ai_spec
require('mini.ai').setup({
  n_lines = 500,
  custom_textobjects = {
    B = gen_ai_spec.buffer(),
    D = gen_ai_spec.diagnostic(),
    I = gen_ai_spec.indent(),
    L = gen_ai_spec.line(),
    N = gen_ai_spec.number(),
    f = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    c = gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
    o = gen_spec.treesitter({
      a = { '@conditional.outer', '@loop.outer' },
      i = { '@conditional.inner', '@loop.inner' }
    }),
  }
})

local clue = require('mini.clue')
clue.setup({
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<leader>' },

    -- `[` and `]` keys
    { mode = 'n',          keys = '[' },
    { mode = 'n',          keys = ']' },

    -- Built-in completion
    { mode = 'i',          keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n',          keys = '<C-w>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    { mode = 'n', keys = '<leader>p',  desc = '+pick' },
    { mode = 'n', keys = '<leader>pg', desc = '+git' },
    { mode = 'n', keys = '<leader>ps', desc = '+symbols' },
    { mode = 'n', keys = '<leader>c',  desc = '+clear' },
    { mode = 'n', keys = '<leader>t',  desc = '+term' },
    clue.gen_clues.square_brackets(),
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows(),
    clue.gen_clues.z(),
  },
  window = {
    width = 'auto',
    delay = 0,
  },
})

require('mini.pick').setup({
  window = {
    config = function()
      -- center the window
      local height = math.floor(0.618 * vim.o.lines)
      local width = math.floor(0.618 * vim.o.columns)
      return {
        anchor = 'NW',
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
        border = 'bold'
      }
    end
  }
})
local pick = require('mini.pick')
local extra = require('mini.extra').pickers

-- Builtins
vim.keymap.set('n', '<leader>pf', pick.builtin.files, { desc = '[f]iles' })
vim.keymap.set('n', '<leader>p/', pick.builtin.grep_live, { desc = 'live grep' })
vim.keymap.set('n', '<leader>pb', pick.builtin.buffers, { desc = '[b]uffers' })
vim.keymap.set('n', '<leader>ph', pick.builtin.help, { desc = '[h]elp tags' })

-- Core
vim.keymap.set('n', '<leader>pH', extra.hipatterns, { desc = '[H]ipatterns' })
vim.keymap.set('n', '<leader>p:', extra.history, { desc = '[:] history' })
vim.keymap.set('n', '<leader>pc', extra.commands, { desc = '[c]ommands' })
vim.keymap.set('n', '<leader>po', extra.oldfiles, { desc = '[o]ld files' })
vim.keymap.set('n', '<leader>pm', extra.marks, { desc = '[m]arks' })
vim.keymap.set('n', '<leader>pr', extra.registers, { desc = '[r]egisters' })
vim.keymap.set('n', '<leader>pO', extra.options, { desc = '[O]ptions' })
vim.keymap.set('n', '<leader>pK', extra.keymaps, { desc = '[K]eymaps' })
vim.keymap.set('n', '<leader>pd', extra.diagnostic, { desc = '[d]iagnostics' })
vim.keymap.set('n', '<leader>pt', extra.treesitter, { desc = '[t]reesitter' })
vim.keymap.set('n', '<leader>pz', extra.spellsuggest, { desc = '[z]= spell' })
vim.keymap.set('n', '<leader>pl', function() extra.list({ scope = 'quickfix' }) end,
  { desc = '[l] quickfix list' })
vim.keymap.set('n', '<leader>pL', function() extra.list({ scope = 'location' }) end,
  { desc = '[L]ocation list' })
vim.keymap.set('n', '<leader>pP', extra.colorschemes, { desc = '[P]alette (colorscheme)' })

-- Git
vim.keymap.set('n', '<leader>pgc', extra.git_commits, { desc = '[c]ommits' })
vim.keymap.set('n', '<leader>pgb', extra.git_branches, { desc = '[b]ranches' })
vim.keymap.set('n', '<leader>pgf', extra.git_files, { desc = '[f]iles' })
vim.keymap.set('n', '<leader>pgh', extra.git_hunks, { desc = '[h]unks' })
vim.keymap.set('n', '<leader>pgs', function() extra.git_hunks({ scope = 'staged' }) end,
  { desc = '[s]taged hunks' })

-- Autocomplete
require('blink.cmp').setup({
  keymap = {
    preset = 'super-tab',
    ['<C-e>'] = { 'show', 'show_documentation', 'hide' },
  },
  signature = {
    enabled = true,
  },
  enabled = function() return not vim.tbl_contains({ "txt", "markdown" }, vim.bo.filetype) end,
  completion = {
    menu = {
      auto_show_delay_ms = 200,
    }
  }
})

-- Formatting
-- symlink formatting configs to home directory
local home = vim.fn.expand('~')
local nvim_dir = vim.fn.stdpath('config') -- Resolves to ~/.config/nvim

local dotfiles = {
  ['.clang-format'] = nvim_dir .. '/.clang-format',
  ['.editorconfig'] = nvim_dir .. '/.editorconfig',
}

for link_name, target_path in pairs(dotfiles) do
  local home_path = home .. '/' .. link_name
  -- Check if the symlink or file doesn't exist yet
  if vim.fn.filereadable(home_path) == 0 and vim.fn.isdirectory(home_path) == 0 then
    -- Creates a symbolic link natively
    vim.uv.fs_symlink(target_path, home_path)
    print('Created symlink for ' .. link_name)
  end
end

local cf = require('conform')
cf.setup({
  formatters_by_ft = {
    python = { 'black' },
  },
})

vim.keymap.set('n', '<leader>f', function()
  cf.format({ async = true, lsp_format = 'fallback' })
end, { desc = '[f]ormat buffer' })

local formatOnSave = false
if formatOnSave then
  cf.setup({
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  })
end

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
    'clangd',
    'pyright',
    'black',
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
          'require',
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--function-arg-placeholders=0',
    '--header-insertion=never'
  },
})

require('mason-lspconfig').setup({
  automatic_enable = true, -- runs vim.lsp.enable()
})

-- LSP Keymaps Create an augroup to ensure this doesn't get duplicated if you reload your config

-- Jump directly if LSP returns a single location; open the mini.extra picker otherwise
local function extra_lsp_or_jump(scope)
  local from = vim.fn.getpos('.')
  from[1] = vim.api.nvim_get_current_buf()
  local tagname = vim.fn.expand('<cword>')

  local opts = {
    on_list = function(data)
      local items = data.items
      if #items == 1 then
        local item = items[1]
        local b = item.bufnr or vim.fn.bufadd(item.filename)
        -- Save position in jumplist
        vim.cmd("normal! m'")
        -- Push a new item into tagstack
        vim.fn.settagstack(
          vim.fn.win_getid(vim.api.nvim_get_current_win()),
          { items = { { tagname = tagname, from = from } } },
          't'
        )
        vim.bo[b].buflisted = true
        vim.api.nvim_win_set_buf(0, b)
        vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
        -- Open folds under the cursor
        vim.cmd('normal! zv')
      else
        extra.lsp({ scope = scope })
      end
    end,
  }

  if scope == 'references' then
    vim.lsp.buf.references(nil, opts)
  else
    vim.lsp.buf[scope](opts)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(event)
    -- 1. Create a helper function to easily map keys specifically to THIS buffer.
    -- Passing `{ buffer = event.buf }` is the magic that prevents global pollution.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- 2. Define your keymaps
    map('K', vim.lsp.buf.hover, 'Hover documentation')
    map('grd', function() extra_lsp_or_jump('definition') end, '[g]o to [d]efinition')
    map('grD', function() extra_lsp_or_jump('declaration') end, '[g]o to [D]eclaration')
    map('grr', function() extra_lsp_or_jump('references') end, '[g]o to [r]eferences')
    map('gri', function() extra_lsp_or_jump('implementation') end, '[g]o to [i]mplementation')
    map('grT', function() extra_lsp_or_jump('type_definition') end, '[g]o to [T]ype definition')
    map('grn', vim.lsp.buf.rename, '[r]e[n]ame symbol')
    map('gra', vim.lsp.buf.code_action, 'code [a]ction')

    map('<leader>psd', function() extra.lsp({ scope = 'document_symbol' }) end, '[d]ocument symbols')
    map('<leader>psw', function() extra.lsp({ scope = 'workspace_symbol_live' }) end, '[w]orkspace symbols')
    clue.ensure_buf_triggers()
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
    priority = 3000,
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
})

-- --------------------------- TREESITTER ----------------------------
vim.pack.add({
  gh 'nvim-treesitter/nvim-treesitter',
  gh 'nvim-treesitter/nvim-treesitter-textobjects'
})

-- 1. Configure the plugin to manage your parser downloads
require('nvim-treesitter').setup({
  ensure_installed = {
    "c",
    "cpp",
    "lua",
    "python",
    "markdown",
    "markdown_inline"
  },
  auto_install = true,
  textobjects = {
    move = {
      enable = true,
      set_jumps = true,             -- Adds these movements to your jumplist (<C-o> to go back)
      goto_next_start = {
        ["]m"] = "@function.outer", -- Jump to the start of the next function
        ["]]"] = "@class.outer",    -- Jump to the start of the next class
      },
      goto_previous_start = {
        ["[m"] = "@function.outer", -- Jump to the start of the previous function
        ["[["] = "@class.outer",    -- Jump to the start of the previous class
      },
    },
  },
})

-- sets ]<letter> and [<letter> keymaps for a given object
local function set_move_keymaps(object, letter)
  -- next keymaps prefixed with ]
  vim.keymap.set({ "n", "x", "o" }, "]" .. letter, function()
    require("nvim-treesitter-textobjects.move").goto_next_start('@' .. object .. '.outer', 'textobjects')
  end, { desc = "Go to next " .. object })

  -- prev keymaps prefixed with [
  vim.keymap.set({ "n", "x", "o" }, "[" .. letter, function()
    require("nvim-treesitter-textobjects.move").goto_previous_start('@' .. object .. '.outer', 'textobjects')
  end, { desc = "Go to previous " .. object })
end

set_move_keymaps('function', 'm')
set_move_keymaps('class', 'c')

-- 2. Trigger native highlighting, folding, and indentation
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    -- Get the buffer number and the associated Treesitter language
    local buf = args.buf
    local language = vim.treesitter.language.get_lang(vim.bo[buf].filetype)

    if not language then
      return
    end

    -- Safely start the native Treesitter highlighting engine
    pcall(vim.treesitter.start, buf, language)

    -- ENABLE FOLDING
    -- Tells Neovim to fold based on structural expressions rather than syntax or indentation
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- ENABLE INDENTATION
    -- Check if the specific language parser includes an indentation map
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- If it does, dynamically override Neovim's default indentation behavior
    if has_indent_query then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
