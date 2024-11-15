set splitright
set encoding=utf-8        
set nocompatible           
set hlsearch
syntax enable               
filetype plugin indent on
set wildmenu
set path+=**


" vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))  
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs  
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC      
endif

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'jpalardy/vim-slime'
"Plug 'ErichDonGubler/vim-sublime-monokai'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'Valloric/YouCompleteMe'
Plug 'rust-lang/rust.vim'
Plug 'kien/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'simnalamburt/vim-mundo'
Plug 'pangloss/vim-javascript'
Plug 'hallison/vim-markdown'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'vim-scripts/DetectIndent'
" Typescript support
Plug 'leafgarland/typescript-vim'
Plug 'git://git.wincent.com/command-t.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}

call plug#end()

" plug configs
let g:airline_powerline_fonts = 1            
let g:airline#extensions#keymap#enabled = 0   
let g:airline_section_z = "\ue0a1:%l/%L Col:%c"
let g:airline_section_y = ""
let g:Powerline_symbols='unicode'              
let g:airline#extensions#xkblayout#enabled = 0
let g:slime_target = "vimterminal"

" rust autosave 
let g:rustfmt_autosave = 1

"colorschemes
"colorscheme sublimemonokai
hi Pmenu ctermbg=lightgrey
hi PmenuSel ctermbg=darkblue

set guifont=Fura\ Code\ Light\ Nerd\ Font\ Complete:h16
"set guifont=JetBrainsMono-Regular:h16

" misc conf
filetype plugin indent on
set hidden
set tabstop=4 shiftwidth=4 expandtab
let mapleader = ","

" tab through buffers
noremap <silent> <S-Tab> :bp<CR>
" show/hide linenos
nnoremap <C-G> :set invnumber<CR>

" move through screen lines instead of file lines
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Up> <C-o>gk
nnoremap <silent> <Down> gj
nnoremap <silent> <Up> gk

" EDITOR
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_winsize = 20
set wmw=0
set number

" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

" fix typos
command Q q
command W w
command Wq wq

" scratchpad
command Scratch new|setlocal buftype=nofile|setlocal bufhidden=hide|setlocal noswapfile|only

" swap and backup files
"set noswapfile
"set nowb
"set directory=~/.vim/swap/


" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
"set signcolumn=yes

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

"filetype plugin on
autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript
let g:ale_linters = {
            \   'python': ['flake8', 'pylint'],
            \   'javascript': ['eslint'],
            \   'vue': ['eslint']
            \}
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
