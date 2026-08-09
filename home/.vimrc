" ~/.vimrc
"
" Deliberately plugin-free. Neovim is the real editor here (~/.config/nvim);
" this is for quick edits and anywhere nvim isn't installed. Nothing to install,
" nothing to update, no plugin manager.

" ---------------------------------------------------------------------------
" Defaults
" ---------------------------------------------------------------------------
" Vim skips $VIMRUNTIME/defaults.vim whenever a ~/.vimrc exists, which costs us
" incsearch, wildmenu, scrolloff, ruler and the cursor-position restore. Take
" it explicitly, then override.
if filereadable($VIMRUNTIME . '/defaults.vim')
  unlet! g:skip_defaults_vim
  source $VIMRUNTIME/defaults.vim
endif
set mouse=              " defaults.vim enables it; keep terminal text selection

filetype plugin indent on
syntax enable

" ---------------------------------------------------------------------------
" Indentation
" ---------------------------------------------------------------------------
set tabstop=4           " a <Tab> renders 4 columns wide (it is still one \t)
set shiftwidth=4        " >> and << shift by 4
set softtabstop=4
set noexpandtab         " keep real tabs
set autoindent
set smartindent

command! Tabs2 setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab   | retab!
command! Tabs4 setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab | retab!

" ---------------------------------------------------------------------------
" Editing / UI
" ---------------------------------------------------------------------------
set number relativenumber
set nowrap
set signcolumn=yes
set laststatus=2
set hidden              " keep modified buffers alive in the background
set backspace=indent,eol,start
set clipboard=unnamed   " y/p use the macOS clipboard
set completeopt-=preview
set colorcolumn=80

" smartcase does nothing without ignorecase — the pair is the point:
" lowercase pattern = case-insensitive, any capital = exact match.
set ignorecase
set smartcase
set hlsearch            " defaults.vim maps <C-L> to clear the highlight

" ---------------------------------------------------------------------------
" Files
" ---------------------------------------------------------------------------
" Swap for crash recovery and persistent undo, but no backup copies — those
" were 23MB of stale duplicates of files that are all in git anyway.
set swapfile
set nobackup
set undofile
set undodir=~/.vim/undodir
if !isdirectory(expand('~/.vim/undodir'))
  call mkdir(expand('~/.vim/undodir'), 'p', 0700)
endif

" ---------------------------------------------------------------------------
" Colors
" ---------------------------------------------------------------------------
augroup vimrc_colors
  autocmd!
  " A colorscheme resets every highlight group, so re-apply after each load.
  autocmd ColorScheme * highlight ColorColumn ctermbg=238
augroup END
colorscheme default

" ---------------------------------------------------------------------------
" Mappings
" ---------------------------------------------------------------------------
" 500ms is enough to type a two-key sequence without <leader> feeling stuck.
set timeout timeoutlen=500 ttimeoutlen=10

nnoremap <Space> <Nop>
let mapleader = " "

" Yank the whole buffer to the system clipboard without moving the cursor.
nnoremap <silent> gA :%y+<CR>

" Jump back after gf, because <C-^> is far too inconvenient.
nnoremap gb <C-o>

" Window movement
nnoremap <silent> <leader>h <C-w>h
nnoremap <silent> <leader>j <C-w>j
nnoremap <silent> <leader>k <C-w>k
nnoremap <silent> <leader>l <C-w>l
" Window rearranging
nnoremap <silent> <leader>H <C-w>H
nnoremap <silent> <leader>J <C-w>J
nnoremap <silent> <leader>K <C-w>K
nnoremap <silent> <leader>L <C-w>L

" Tabs
nnoremap <silent> <leader>e :tabedit<CR>
nnoremap <silent> <leader>n :tabnext<CR>
nnoremap <silent> <leader>] :tabnext<CR>
nnoremap <silent> <leader>[ :tabprevious<CR>

" Splits
nnoremap <silent> <leader>vr :vertical resize 30<CR>
nnoremap <silent> <leader>+  :vertical resize +5<CR>
nnoremap <silent> <leader>-  :vertical resize -5<CR>

" File explorer (netrw, built in)
nnoremap <silent> <F1> :Explore<CR>
nnoremap <silent> <leader>pv :vsplit <bar> Explore <bar> vertical resize 30<CR>

nnoremap <silent> <leader>pc :pclose<CR>

" Find files without a fuzzy finder: :find matches recursively from cwd.
set path=.,**
set wildmenu
nnoremap <leader>f :find<Space>

" Grep with ripgrep if it's around, then :copen to browse the hits.
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
nnoremap <leader>ps :grep<Space>

" ---------------------------------------------------------------------------
" netrw
" ---------------------------------------------------------------------------
let g:netrw_browse_split = 2    " open files in a new vsplit; 4 = reuse previous
let g:netrw_banner = 0
let g:netrw_winsize = 25

" ---------------------------------------------------------------------------
" Completion
" ---------------------------------------------------------------------------
" Built-in only: <C-n>/<C-p> buffer words, <C-x><C-f> filenames,
" <C-x><C-o> omni (filetype-aware, falls back to syntax).
set omnifunc=syntaxcomplete#Complete
