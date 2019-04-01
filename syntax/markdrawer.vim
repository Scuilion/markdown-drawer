if exists('b:current_syntax')
    finish
endif

let b:current_syntax = 'markdrawer'

execute 'highlight ToDelete ctermfg=' . g:markdrawerToDeleteColor 
