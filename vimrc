set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle/'))
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
NeoBundleFetch 'Shougo/neobundle.vim'
" " plugin on GitHub repo
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'bitc/vim-hdevtools'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'bling/vim-airline'
NeoBundle 'edkolev/tmuxline.vim'
NeoBundle 'ervandew/supertab'
NeoBundle 'eagletmt/neco-ghc'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'vim-voom/VOoM'
" might install this if ever working in a
" language that needs alternate files
" NeoBundle 'mopp/next-alter.vim'
" Try unite rather than CtrlP
" try neocomplete (rather than neocomplache)
" or youcompleteme (replacing supertab maybe)
"
" may be vim-indent-object

NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" make airline show up with first split
set laststatus=2
" symbols for vim-airline
let g:airline_powerline_fonts = 1

nnoremap <F5> :GundoToggle<CR>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap = <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" syntax highlighting
syntax on

" keep ex from popping up
nnoremap Q <nop>

" tap omni-completion
let g:SuperTabDefaultCompletionType="context"
" let g:SuperTabDefaultCompletionType="<C-x><C-o>"

" automatic indenting
set ai
" retain visual selection when indenting
vnoremap > >gv
vnoremap < <gv

" general good idea
set title
set hidden
nnoremap ` '
nnoremap ' `
filetype on
filetype plugin on
filetype indent on
set splitbelow
set showcmd

au FileType tex set spell

" because we have a dark screen
set bg=dark
set t_Co=256
" let g:solarized_termcolors=256
colorscheme solarized
let g:airline_theme='solarized'

" set history length
set history=1000

" for smart tab completion
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*.hi,*.swp

" number lines
set number
" set relativenumber
set ruler

" set the text width
" set tw=75
set tw=0
set showbreak=↪

" For dealing with tabs
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shiftround

let mapleader=",,"

" For haskellmode for vim
au FileType haskell nnoremap <buffer> <leader>t :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <leader>i :HdevtoolsInfo<CR>
au FileType haskell nnoremap <buffer> <leader>c :HdevtoolsClear<CR>
" au Bufenter *.hs compiler ghc
" let g:haddock_browser = "/usr/bin/firefox"

" " Making $stuff$ a text object for LaTeX files. Copied from somewhere on
" " internet.
" " Should probably restrict this to .tex files
" function! Dollar(inner)
"   call search('\$', 'bW')
"   if a:inner
"     " The following is simply my emulation of execute "normal \<Space>"
"     " which does not exist and for which I haven't found an alternative.
"     let tmp_pos = getpos('.')
"     normal! l
"     if getpos('.') == tmp_pos
"       normal! j0
"     endif
"   endif
"   normal! v
"   call search('\$', 'W')
"   if a:inner
"     execute "normal! \<BS>"
"   endif
" endfunction
" onoremap <silent>i$ :<C-u>call Dollar(1)<CR>
" onoremap <silent>a$ :<C-u>call Dollar(0)<CR>
" vnoremap <silent>i$ <Esc>:call Dollar(1)<CR><Esc>gv
" vnoremap <silent>a$ <Esc>:call Dollar(0)<CR><Esc>gv

" save and load folds automatically
" Disabled while trying syntastic
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview

" we also want persistent undo
set undofile
set undodir=~/.vim/undodir

" for the purposes of syntastic
" let g:syntastic_check_on_open=1 " disabled as it takes a long time
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1 " autocloses and autoopen
let g:syntastic_always_populate_loc_list=1
let g:syntastic_haskell_hlint_args='--ignore=Parse error'
let g:syntastic_tex_checkers=['chktex'] " lacheck is mostly crap


" " FOR OCAML
" " Vim needs to be built with Python scripting support, and must be
" " able to find Merlin's executable on PATH.
" if executable('ocamlmerlin') && has('python')
"   let s:ocamlmerlin = substitute(system('opam config var share'), '\n$', '', '''') . "/ocamlmerlin"
"   execute "set rtp+=".s:ocamlmerlin."/vim"
"   execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
" endif
"
" " autocmd FileType ocaml source substitute(system('opam config var share'), '\n$', '', '''') . "/typerex/ocp-indent/ocp-indent.vim"
