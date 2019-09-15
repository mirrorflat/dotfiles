" ########
" INSTALL
" ########
"
" initial(win):
" $ cd $HOME
" $ git clone https://github.com/k-takata/minpac.git vimfiles\pack\minpac\opt\minpac
"
" initial(mac):
" $ mkdir -p ~/.vim/pack/minpac/opt
" $ cd ~/.vim/pack/minpac/opt
" $ git clone https://github.com/k-takata/minpac.git
"
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
" $ pip install docutils pygments

" ===========
" OPERATIONS
" ===========
"
" Install or update plugins:
" call minpac#update()
" clean plugins:
" call minpac#clean()
"
" (for mac)
" ref: https://qiita.com/k-takata/items/36c240a23f88d699ce86
" $ brew install --HEAD universal-ctags/universal-ctags/universal-ctags
" $ touch ~/devel/.tags
" ref: https://qiita.com/aratana_tamutomo/items/59fb4c377863a385e032

" =====
" MAIN
" =====
"
" Package management
" --------------------
packadd minpac
call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('vim-syntastic/syntastic')
call minpac#add('nathanaelkane/vim-indent-guides')
call minpac#add('previm/previm')
call minpac#add('tyru/open-browser.vim')


" -------------------
"  ReStructuredText
" -------------------

" previm
" ---------
" (for mac)
" https://kashewnuts.github.io/2016/05/25/markupenv.html
" following command was needed to show preview correctly.
" 'opacity' in mermaid.min.css make things wrong...
" $ rm ~/.vim/pack/minpac/start/previm/preview/css/lib/mermaid.min.css
let g:previm_show_header = 0
autocmd FileType rst nnoremap <C-P> :PrevimOpen<CR>


" --------------
"  Python
" --------------

" syntastic
" -----------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']
"disable syntastic on a per buffer basis (some work files blow it up)
function! SyntasticDisableBuffer()
    let b:syntastic_skip_checks = 1
    SyntasticReset
    echo 'Syntastic disabled for this buffer'
endfunction
command! SyntasticDisableBuffer call SyntasticDisableBuffer()


" Execute python script with Ctrl-P 
" ------------------------------------
autocmd BufNewFile,BufRead *.py nnoremap <C-P> :!python %<CR>


" Python Indent
" ---------------
filetype indent plugin on
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl expandtab tabstop=4 shiftwidth=4 softtabstop=4


" Auto formatting
" -----------------
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
    if has('mac') || has('unix')
        call Preserve(':silent %!pyformat --remove-all-unused-imports -a % |patch -o /tmp/pyformat.py %  > /dev/null && if [ $(cat /tmp/pyformat.py |wc -l ) -gt 1 ] ; then isort -d /tmp/pyformat.py;  else  isort -d %; fi')
    elseif has('win32') || has ('win64')
        " do some if needed.
    endif
endfunction
autocmd FileType python nnoremap <S-f> :call AutoFormat()<CR>


" -----------
" Tag jump
" -----------

" jump
" -----
set tags=tags
nnoremap <C-]> g<C-]>


" ctag
" -----
set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis
set tags=.tags;$HOME
function! s:execute_ctags() abort
  " 探すタグファイル名とディレクトリ
  let tag_name = '.tags'
  let tags_dirpath = '~/devel/'
  " ディレクトリを遡り、タグファイルを探し、パス取得
  let tags_path = findfile(tag_name, '.;')
  " タグファイルパスが見つからなかった場合
  if tags_path ==# ''
    return
  endif
  " タグファイルのディレクトリに移動して、ctagsをバックグラウンド実行（エラー出力破棄）
  execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
endfunction
augroup ctags
  autocmd!
  autocmd BufWritePost * call s:execute_ctags()
augroup END


" --------------
"  General
" --------------

" Basic 
" -------
colorscheme default
syntax on
set expandtab
set tabstop=4
set shiftwidth=4
set vb t_vb=


" vim-indent-guides
" -------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 30
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=2
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=4


" sequential indent 
" -------------------
vnoremap < <gv
vnoremap > >gv


" to edit .vimrc
nnoremap <Space>. :<C-u>edit ~/.vimrc<CR>
nnoremap <Space>s. :<C-u>source ~/.vimrc<CR>


" Draw underline on current line
augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter,BufRead * set cursorline
augroup END
