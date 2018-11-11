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
    let l:i = 0
    let l:goto = 0
    while i < len(s:outline)
        if 1 == s:outline[i].active
            let l:goto = i + 1
        endif
        let l:i += 1
    endwhile
    execute "normal! " . l:goto . "G"
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
    let s:outline = []
    let found = 0
    let pat = '^#\+'
    let numOfLines = line('$')
    let i = 1
    while i <= numOfLines
       let line = getline(i)
       let h = matchend(line, pat)
       if h > 0
           call add(s:outline, {'fileLineNum': i, 'active': 0, 'header': repeat(' ', h-1) . strcharpart(line, h+1)})
       endif
       let i += 1
    endwhile

    let currline = line('.')
    let i = len(s:outline) - 1
    while i > -1
        if currline >= s:outline[i].fileLineNum
            let s:outline[i].active = 1
            "break
            let i = -1
        endif
        let i -= 1
    endwhile
endfunction

function! CreateTree()
    let list = []
    for i in s:outline
        call add(list, i.header)
    endfor
    return list
endfunction

noremap <buffer> <localleader>r :call OpenMarkdownDrawer()<cr>
