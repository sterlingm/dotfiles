" Allows Vim-related packages in Debian to work
runtime! debian.vim

" debian.vim sets 'nocompatible'. Setting 'compatible' changes numerous
" options, so any other options should be set AFTER explicitly setting 'compatible'.
" Set nocompatible for everything to enforce this
set nocompatible

" When we split a window, make sure we can write to that file
set noreadonly

" Set highlighting for syntax
if has("syntax")
  syntax on
endif 

" Set colorscheme
colorscheme elflord 


" detect file type
filetype on
filetype plugin on


" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark


" Make the finding feature not worry about case until you use capital letter
set ignorecase
set smartcase

" Makes the lines auto indent		
set smartindent

" Makes tab key use spaces instead of literal tabs
set expandtab

" Sets how many columns a tab counts for
set tabstop=2

" Makes all existing tab characters match current settings
retab

"Sets how many characters are used for indentation
set shiftwidth=2

"Makes backspace delete over line-breaks, automatically inserted indents, etc
set backspace=2

" Enables mouse use when you press 'a'
set mouse=a

" Show line numbers
set number

" Sets the number of commands to remember 
set history=50

" Sets the status line to always be present
set laststatus=2

" Enables incremental searching
set incsearch

" Sets the amount of lines to have above or below the cursor at all times
set scrolloff=2


"-----Colemak remappings-----"
" Remap the scrolling keys for colemak
noremap n j|noremap e k|noremap i l

" Remap s/S to i/I  
noremap s i|noremap S I

" Remap k/K to n/N
noremap k n|noremap K N



" Options for auto completion
set completeopt=menuone,menu,longest,preview



" Lets the tag list plugin use ctags
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
" Build tags for current directory with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>


" Create a command to toggle NERDTree and TlistToggle at the same time
com TT NERDTreeToggle | TlistToggle

" Map a key to the TT command
noremap <F6> :TT<cr>

" Make Taglist split the window horizontally
let Tlist_Use_Horiz_Window = 1

" Set the Tlist window height to be half of the overall window height
" This lets the NERDTree and Taglist share half of the vsplit window space
" To make the Taglist window be half of the split size, you must also change in taglist.vim in if block "if g:Tlist_Use_Horiz_Window" (~ line 1350), let win_dir = 'bo' to let win_dir = 'rightb'. 'bo' will make it take over the bottom of the entire vim window
let Tlist_WinHeight = winheight(0) / 2

