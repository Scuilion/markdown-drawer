function! OpenMarkdownDrawer()
    " Save first
    write

    " TODO: Prevent multiple versions of the Drawer
    " see -> :help bufwinnr()

    let l:filename = expand('%:t')

    " Open a new split
    vsplit __Markdown_Drawer__ 100
    vertical resize 25
    normal! ggdG
    setlocal filetype=markdowndrawer
    setlocal buftype=nofile

    " Insert tree
    call append(0, "Outline of" . " " . l:filename)
endfunction

noremap <buffer> <localleader>r :call OpenMarkdownDrawer()<cr>
