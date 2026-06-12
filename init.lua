-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

vim.o.number = true -- Show line numbers in a column.

-- Show line numbers relative to where the cursor is.
-- Affects the 'number' option above, see `:h number_relativenumber`.
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 10 -- Keep this many screen lines above/below the cursor.
vim.o.list = true -- Show <tab> and trailing spaces.

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.hl_op()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.hl_op()
  end,
})

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Use <leader>-e to toggle file tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', defaults)

-- Modify tab width
vim.cmd('set shiftwidth=2')
    
-- Load custom plugins
vim.pack.add({

  'https://github.com/nvim-tree/nvim-web-devicons', -- icons for file formats

  'https://github.com/nvim-tree/nvim-tree.lua', -- file tree

  'https://github.com/neovim/nvim-lspconfig', -- language support

  'https://github.com/romgrk/barbar.nvim', -- files top bar

  'https://github.com/nvim-treesitter/nvim-treesitter',

  'https://github.com/nvim-lualine/lualine.nvim', -- bottom info bar

  'https://github.com/nvimdev/dashboard-nvim', -- greeter

  'https://github.com/folke/tokyonight.nvim', -- tokyonight theme

  'https://github.com/navarasu/onedark.nvim', -- onedark theme

  'https://github.com/windwp/nvim-autopairs', -- autopairs for example ()

  'https://github.com/lukas-reineke/indent-blankline.nvim',

  'https://github.com/hrsh7th/nvim-cmp', -- LSP autocompletion

  'https://github.com/hrsh7th/cmp-nvim-lsp',-- LSP dependency

  'https://github.com/hrsh7th/cmp-buffer', -- LSP dependency

  'https://github.com/hrsh7th/cmp-path', -- LSP dependency

})

-- Select theme
--vim.cmd[[colorscheme tokyonight-night]]

require('onedark').setup {
    style = 'deep'
}
require('onedark').load()

-- Greeter config
require('dashboard').setup {
  theme = 'doom'    -- theme is doom and hyper default is hyper
}

-- Load default configs for some plugins
require('nvim-tree').setup()
require('lualine').setup()
require('nvim-autopairs').setup()
require('ibl').setup()

-- Enable language support
vim.lsp.enable('clangd')

-- Autocompletion config for LSP
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})
