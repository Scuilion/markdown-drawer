" MarkdownDrawer

let s:drawerName = "__Markdown_Drawer__"
let s:outline = []

function! OpenMarkdownDrawer()
    let s:outline = []
    " Save first
    write

    call CreateOutline()

    let l:filename = expand('%:t')
    " Insert tree

    " Prevent multiple versions of the Drawer
    if !ReuseWindow()
        call CreateNewWindow()
    else
        execute bufwinnr(s:drawerName) . 'wincmd w'
    endif

    normal! ggdG
    call append(0, ["Outline of" . " " . l:filename] + s:outline)

endfunction

function! CreateNewWindow()
    execute "vsplit" s:drawerName
    vertical resize 25
    setlocal filetype=markdowndrawer
    setlocal buftype=nofile
endfunction

function! ReuseWindow()
    let l:path = expand('%:p')

    let l:buff = bufwinnr(s:drawerName)

    if l:buff != -1
        return 1
    endif

    return 0
endfunction

function! CreateOutline()
    call MarkdownLevel()
endfunction

function! MarkdownLevel()
    let l:headers = []
    let l:numOfLines = line('$')
    echom l:numOfLines
    let l:c = 1
    while c <= numOfLines
       let h = matchstr(getline(c), '^#\+')
       echom h
       if !empty(h)
           call add(l:headers, c)
       endif
       let c += 1
    endwhile
    echom string(l:headers)
endfunction

noremap <buffer> <localleader>r :call OpenMarkdownDrawer()<cr>
