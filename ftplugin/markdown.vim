" Maintainer:   Kevin O'Neal oneal.kevin@gmail.com
" Version:      0.1

if !exists("g:markdrawerPrefix")
    let g:markdrawerPrefix = " "
endif

if !exists("g:markdrawerGoto")
    let g:markdrawerGoto = "o"
endif

if !exists("g:markdrawerDelete")
    let g:markdrawerDelete = "D"
endif

if !exists("g:markdrawerPasteBelow")
    let g:markdrawerPasteBelow = "p"
endif

if !exists("g:markdrawerIncrease")
    let g:markdrawerIncrease = "+"
endif

if !exists("g:markdrawerDecrease")
    let g:markdrawerDecrease = "-"
endif

noremap <buffer> <leader>md :call ui#OpenMarkdownDrawer()<cr>
