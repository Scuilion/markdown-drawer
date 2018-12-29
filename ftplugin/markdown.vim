if !exists("g:markdrawerPrefix")
    let g:markdrawerPrefix = " "
endif

if !exists("g:markdrawerGoto")
    let g:markdrawerGoto = "o"
endif

if !exists("g:markdrawerYank")
    let g:markdrawerYank = "Y"
endif

if !exists("g:markdrawerPasteBelow")
    let g:markdrawerPasteBelow = "p"
endif

if !exists("g:markdrawerPasteAbove")
    let g:markdrawerPasteAbove = "P"
endif

noremap <buffer> <leader>md :call ui#OpenMarkdownDrawer()<cr>
