" GENERAL ---------------------------------------------------------------- {{{

set nocompatible
filetype on
filetype plugin on
filetype indent on

syntax on

set scrolloff=8
" set nowrap
set incsearch
set ignorecase
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set history=1000

set autoindent
set smartindent
set shiftwidth=4
set tabstop=4
set expandtab

set number relativenumber
set nu rnu
set mouse=a
set cursorline
set cursorcolumn

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

set foldmethod=syntax
set nofoldenable

" }}}


" PLUGINS ---------------------------------------------------------------- {{{



" ====== PLUGINS REMINDER (all the cool stuff I forgot about) ======
"
" === Autocomplete ===
" :Mason - show installed language servers
" :LspInfo - LSP clients attached to current buffer
" :LspInstall - install an LSP server
" 
" === Language specific ===
" :MarkdownPreview - open a live markdown renderer in browser
"
" === netrw (+vinegar) ===
" gh - toggle dotfiles, ~ to go up a dir
" y. - yank absolute path to file under selection
" .!<shell command> - run a command with filename from under cursor
" appended at the end
"
" === Startify ===
" On greeter screen, mark (multiple) files with b (open in same window), s (split), v
" (vertical split) or t (tab), and then execute with <cr>
"
" === Fun stuff ===
" :StartupTime - check which plugins affect vim startup time the most
"
" === Build-in functionality I keep forgetting about ===
" :te(rm) - open terminal
" okay listen here
noremap <space> <C-w>
" See this? Use it. Having multiple windows open inside vim makes less of a
" mess than having multiple terminals, each with a different vim instance
" :setlocal spell spelllang=pl - enable spellcheck (TODO AUTO-ENABLE)
" z= - correct word in normal mode

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'doums/darcula'
Plug 'nvim-lualine/lualine.nvim'
" If you want to have icons in your statusline choose one of these
Plug 'nvim-tree/nvim-web-devicons'
Plug 'mhinz/vim-startify'
Plug 'numToStr/Comment.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

Plug 'xuhdev/vim-latex-live-preview'
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
Plug 'tpope/vim-vinegar'
Plug 'dstein64/vim-startuptime'
Plug 'tpope/vim-fugitive'

" autocomplete lol
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
" Plug 'hrsh7th/cmp-luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}
Plug 'rafamadriz/friendly-snippets'

Plug 'phaazon/hop.nvim'

call plug#end()

" comments plugin
lua << EOF
require('Comment').setup({
    toggler = {
        ---Line-comment toggle keymap
        line = '<C-/>',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = '<C-/>',
        ---Block-comment keymap
        block = 'gb',
    },
})

-- lualine
local custom_material = require'lualine.themes.material'

-- Change the background of lualine_c section for normal mode
custom_material.normal.c.bg = '#313335'

require('lualine').setup {
  options = { theme  = custom_material },
  ...
}

EOF

" markdown-preview
let g:mkdp_browser = '/usr/bin/firefox'

" improved wild menu
call wilder#setup({'modes': [':', '/', '?']})

" latex preview
autocmd Filetype tex setl updatetime=1
let g:livepreview_previewer = 'gv'

" hop
" NOTE - hop devs recommend pinning a certain version of the plugin to prevent
" pulling unstable updates. If something breaks, you know where to look for
"
" Imma configure this later lol
lua require'hop'.setup()

" Configure LSP servers with mason and mason-lspconfig, autocomplete with cmp

lua << EOF
    require("mason").setup()

    -- this will automatically setup each server on installation
    local lspconfig = require('lspconfig')

    require('mason-lspconfig').setup_handlers({
         function(server)
                lspconfig[server].setup({})
          end,
      })

    require("mason-lspconfig").setup {
        ensure_installed = { "pyright",
            "bashls",
            "clangd",
            "cmake",
            "dockerls",
            "gradle_ls",
            "html",
            "cssls",
            "jsonls",
            "jdtls",
            "kotlin_language_server", 
            "marksman", 
            "lemminx",
            "yamlls",
            "texlab"
            },
        -- automatic_installation = true  -- this would work the other way around - setup, then auto-install
        }

    -- setup can also be done manually
    --[[ require("lspconfig").pyright.setup {}
    require("lspconfig").clangd.setup {}
    require("lspconfig").cmake.setup {}  ]]--


    -- some random code I found on the intenet
  --[[  vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function()
        local bufmap = function(mode, lhs, rhs)
          local opts = {buffer = true}
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
        bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
        bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
        bufmap('n', '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
        bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
        bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
      end
    })  ]]--


    -- I guess this sets cmp up
    vim.opt.completeopt = {'menu', 'menuone'}

    require('luasnip.loaders.from_vscode').lazy_load()

    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local select_opts = {behavior = cmp.SelectBehavior.Select}

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
      },
      preselect = cmp.PreselectMode.Item,
      window = {
        documentation = cmp.config.window.bordered()
      },
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = 'λ',
            luasnip = '⋗',
            buffer = 'Ω',
            path = '🖫',
          }

          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({select = true}),
        ['<CR>'] = cmp.mapping.confirm({select = true}),

        ['<C-f>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<C-b>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<Tab>'] = cmp.mapping(function(fallback)
          local col = vim.fn.col('.') - 1

          if cmp.visible() then
            cmp.select_next_item(select_opts)
          elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            fallback()
          else
            cmp.complete()
          end
        end, {'i', 's'}),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          else
            fallback()
          end
        end, {'i', 's'}),
      },
    })

EOF

" }}}

" APPEARANCE ---------------------------------------------------------------- {{{

colorscheme darcula
set termguicolors


" }}}
