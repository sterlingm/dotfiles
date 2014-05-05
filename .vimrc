
" Allows Vim-related packages in Debian to work
runtime! debian.vim

" **********************************************************
" Everything in this ******* section is *required* for vundle for work properly

" debian.vim sets 'nocompatible'. Setting 'compatible' changes numerous
" options, so any other options should be set AFTER explicitly setting 'compatible'.
" Set nocompatible for everything to enforce this
set nocompatible
filetype off

" Set runtime path to include vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" Install youcompleteme
Bundle 'Valloric/youcompleteme'


" detect file type
filetype plugin indent on

" **********************************************************


" Set highlighting for syntax
if has("syntax")
  syntax on
endif 

" Set colorscheme
colorscheme elflord 


" When we split a window, make sure we can write to that file
set noreadonly

" If using a dark background within the editing area and syntax highlighting
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

" Set the number of text columns to use before wrapping line
" set columns=80



" Options for auto completion
set completeopt=menuone,menu,longest,preview


" ================= Configure Taglist ================= "
" Lets the tag list plugin use ctags
let Tlist_Ctags_Cmd = "/usr/bin/ctags"

" Make Taglist split the window horizontally
let Tlist_Use_Horiz_Window = 1

" Set the Tlist window height to be half of the overall window height
" This lets the NERDTree and Taglist share half of the vsplit window space
" To make the Taglist window be half of the split size, you must also change 
" taglist.vim in if block: "if g:Tlist_Use_Horiz_Window" (~ line 1287), 
"                           let win_dir = 'botright' to let win_dir = 'rightb'. 
" 'botright' will make it take over the bottom of the entire vim window
let Tlist_WinHeight = winheight(0) / 2
let Tlist_WinWidth = winwidth(0) / 2






" ================= Configure YouCompleteMe =================
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" This represses the confirmation of loading a .ycm_extra_conf file.
" It should probably be left alone, but it is annoying to always confirm when
" working on my own projects everyday.
let g:ycm_confirm_extra_conf = 0

" This closes the preview window that appears after you have selected a
" completion option
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1




" ================= Key Bindings ================= "

" Build tags for current directory with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>

" Create a command to toggle NERDTree and TlistToggle at the same time
com TT NERDTreeToggle | TlistToggle



" Map a key to the TT command
noremap <F6> :TT<cr>




" ============ Colemak remappings ============ "
function! SetColemakRemaps()
    " Remap the scrolling keys for colemak
    noremap n j|noremap e k|noremap i l
    noremap gn gj|noremap ge gk

    " Remap undo key
    " l to u
    noremap l u|noremap L U

    " Remap yank and paste keys
    " j to y
    noremap j y|noremap J Y 

    " Remap insert keys
    " u to i
    " y to o
    noremap u i|noremap U I
    noremap y o|noremap Y O

    " Remap next key for search
    " k to n
    noremap k n|noremap K N

endfunction
" ========================================= "





" ============ Norman remappings ============ "
function! SetNormanRemaps()
    " Remap the scrolling keys for norman
    noremap n j|noremap i k|noremap o l|noremap y h
    noremap gn gj|noremap gi go

    " Remap insert keys
    " r to i
    " l to o  
    noremap r i|noremap R I
    noremap l o|noremap L O

    " Remap yank and paste keys
    " j to y
    " f to p (this is different from conventional 
    "  paste location because ; is in p's location)
    "  f (r in qwerty) is p in Colemak so I'm used to that mapping
    noremap j y|noremap J Y
    noremap f p|noremap F P

    " Remap next key for search
    " p to n
    noremap p n|noremap P N

endfunction
" ========================================= "




" Set key remaps based on which keyboard layout
" is in use - works only for Colemak and Norman layouts
" Relies on 'check_kb_layout.sh' script
function! SetLayoutRemaps()
  
  call system('. ~/check_kb_layout.sh')
  
  if v:shell_error == 1
    call SetNormanRemaps()

  elseif v:shell_error == 2
    call SetColemakRemaps()
  
  endif

endfunction
" ========================================= "


" Call the remap function
call SetLayoutRemaps()


 
