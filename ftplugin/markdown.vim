if !exists("g:markdrawerPrefix")
    let g:markdrawerPrefix = " "
endif

if !exists("g:markdrawerGoto")
    let g:markdrawerGoto = "o"
endif

if !exists("g:markdrawerDelete")
    let g:markdrawerYank = "D"
endif

if !exists("g:markdrawerPasteBelow")
    let g:markdrawerPasteBelow = "p"
endif

noremap <buffer> <leader>md :call ui#OpenMarkdownDrawer()<cr>
