" MarkdownDrawer

let s:drawerName = "__Markdown_Drawer__"

function! OpenMarkdownDrawer()
    " Save first
    write

    " Prevent multiple versions of the Drawer
    if ReuseWindow()
        execute bufwinnr(s:drawerName) . 'wincmd w'
        return
    endif

    let l:filename = expand('%:t')

    " Open a new split
    execute "vsplit" s:drawerName
    vertical resize 25
    normal! ggdG
    setlocal filetype=markdowndrawer
    setlocal buftype=nofile

    " Insert tree
    call append(0, "Outline of" . " " . l:filename)
endfunction

function! ReuseWindow()
    let l:path = expand('%:p')

    let l:buff = bufwinnr(s:drawerName)

    if l:buff != -1
        return 1
    endif

    return 0
endfunction

noremap <buffer> <localleader>r :call OpenMarkdownDrawer()<cr>
