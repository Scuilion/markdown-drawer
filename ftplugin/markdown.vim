" MarkdownDrawer
if !exists("g:markdrawer_prefix")
    let g:markdrawer_prefix = " "
endif

noremap <buffer> <localleader>r :call ui#OpenMarkdownDrawer()<cr>
