" ########
" INSTALL
" ########
" initial:
" $ mkdir -p ~/.vim/pack/minpac/opt
" $ cd ~/.vim/pack/minpac/opt
" $ git clone https://github.com/k-takata/minpac.git
" in python environment:
" $ pip install flake8
" $ pip install flake8-coding
" $ pip install flake8-copyright
" $ pip install flake8-docstrings
" $ pip install flake8-quotes
" $ pip install flake8-import-order
" $ pip install pep8-naming
" $ pip install flake8-print
" $ pip install flake8-todo
" $ pip install pyformat
" $ pip install isort
" $ pip install radon

" ===========
" OPERATIONS
" ===========
" Install or update plugins:
" call minpac#update()
" clean plugins:
" call minpac#clean()
" ref: https://qiita.com/k-takata/items/36c240a23f88d699ce86

" =====
" MAIN
" =====
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('vim-syntastic/syntastic')
call minpac#add('nathanaelkane/vim-indent-guides')
call minpac#add('vim-scripts/Align')
call minpac#add('vim-scripts/SQLUtilities')


" vim-syntastic/syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']


" auto formatting
" original http://stackoverflow.com/questions/12374200/using-uncrustify-with-vim/15513829#15513829
function! Preserve(command)
    " Save the last search.
    let search = @/
    " Save the current cursor position.
    let cursor_position = getpos('.')
    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)
    " Execute the command.
    execute a:command
    " Restore the last search.
    let @/ = search
    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt
    " Restore the previous cursor position.
    call setpos('.', cursor_position)
endfunction

function! AutoFormat()
    call Preserve(':silent %!pyformat --remove-all-unused-imports -a % |patch -o /tmp/pyformat.py %  > /dev/null && if [ $(cat /tmp/pyformat.py |wc -l ) -gt 1 ] ; then isort -d /tmp/pyformat.py;  else  isort -d %; fi')
endfunction

autocmd FileType python nnoremap <S-f> :call AutoFormat()<CR>


" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 30
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=4


" to edit .vimrc
nnoremap <Space>. :<C-u>edit ~/.vimrc<CR>
nnoremap <Space>s. :<C-u>source ~/.vimrc<CR>
 

" Basic 
colorscheme default
syntax on
set expandtab
set tabstop=4
set shiftwidth=4
set vb t_vb=


" Draw underline on current line
augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter,BufRead * set cursorline
augroup END


" Tag jump
set tags=tags
nnoremap <C-]> g<C-]>


" sequential indent 
vnoremap < <gv
vnoremap > >gv


" Python Indent
filetype indent plugin on
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4


" Execute python script with Ctrl-P 
autocmd BufNewFile,BufRead *.py nnoremap <C-P> :!python %<CR>


" Execute sql script with ,s
autocmd BufNewFile,BufRead *.sql nnoremap ,s :!psql -Uterry -hlocalhost -f % cxm<CR>


