" MarkdownDrawer

let s:drawerName = "__Markdown_Drawer__"
let s:outline = []

function! OpenMarkdownDrawer()

    " Save first
    write

    call MarkdownLevel()

    " Prevent multiple versions of the Drawer
    if !ReuseWindow()
        call CreateNewWindow()
    else
        execute bufwinnr(s:drawerName) . 'wincmd w'
    endif

    setlocal noreadonly modifiable
    normal! ggdG
    call append(0, CreateTree())

endfunction

function! CreateTree()
    let list = []
    for i in s:outline
        call add(list, i.header)
    endfor
    return list
endfunction

function! CreateNewWindow()
    execute "vsplit" s:drawerName
    vertical resize 25
    setlocal filetype=markdowndrawer
    setlocal buftype=nofile
endfunction

function! ReuseWindow()
    if bufwinnr(s:drawerName) != -1
        return 1
    endif
    return 0
endfunction

function! MarkdownLevel()
    let found = 0
    let currline = line('.')
    let pat = '^#\+'
    let numOfLines = line('$')
    let i = 1
    while i <= numOfLines
       let line = getline(i)
       let h = matchend(line, pat)
       if h > 0
           let basic = {'lineNum': i, 'active': 0, 'header': strcharpart(line, h+1)}
           if i >= currline && found ==? 0
                let basic.active = 1
                let found = 1
           endif
           call add(s:outline, basic)
       endif
       let i += 1
    endwhile
endfunction

noremap <buffer> <localleader>r :call OpenMarkdownDrawer()<cr>
