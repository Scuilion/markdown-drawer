let s:drawerName = "__Markdown_Drawer__"
let s:outline = []
let s:file = ""
let s:fileLength = 0

function! ui#OpenMarkdownDrawer()
  write

  let s:file = expand("%:p")
  let s:fileLength = line('$')

  let s:outline = levels#MarkdownLevel()

  " Prevent multiple versions of the Drawer
  if !ReuseWindow()
    call CreateNewWindow()
  else
    execute bufwinnr(s:drawerName) . 'wincmd w'
  endif

  setlocal noreadonly modifiable
  normal! ggdG
  call append(0, CreateTree())
  normal! dd

  setlocal readonly nomodifiable

  let l:i = 0
  let l:goto = 0
  while i < len(s:outline)
    if 1 == s:outline[i].active
      let l:goto = i + 1
    endif
    let l:i += 1
  endwhile

  " removing all markers from first header does not set active flag
  if l:goto == 0
    l:goto = 1
  endif

  execute "normal! " . l:goto . "G"
  execute 'nnoremap <buffer> <silent> '. g:markdrawerDelete . ' :call Delete()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawerPasteBelow . ' :call PasteBelow()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawerIncrease . ' :call Increase()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawerDecrease . ' :call Decrease()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawerGoto . ' :call GoTo()<cr>'

endfunction

function! CreateNewWindow()
  execute "vsplit" s:drawerName
  vertical resize 25
  set winfixwidth
  setlocal filetype=markdowndrawer
  setlocal buftype=nofile
endfunction

" if the drawer is already opened
function! ReuseWindow()
  if bufwinnr(s:drawerName) != -1
    return 1
  endif
  return 0
endfunction

function! CreateTree()
  let list = []
  for i in s:outline
    call add(list, i.header)
  endfor
  return list
endfunction

" Finds the where to place cursor base off the outline 
" and returns that line number
function! GoTo()
  let l = s:outline[line('.') - 1].fileLineNum
  execute bufwinnr(s:file) . 'wincmd w'
  execute "normal! " . l . "G"
  return l
endfunction

function! Delete()
  let i = line('.')-1
  let s:dStart = s:outline[i].fileLineNum 
  let s:dEnd = s:fileLength
  if len(s:outline) > i + 1
    let s:dEnd = s:outline[i + 1].fileLineNum - 1
  endif
endfunction

function! PasteBelow()
  if exists("s:dStart") && exists("s:dEnd")
    let l:to = s:fileLength
    if len(s:outline) > line('.')
      let l:to = s:outline[line('.')].fileLineNum - 1
    endif

    execute bufwinnr(s:file) . 'wincmd w'    
    execute s:dStart . "," . s:dEnd . "m " . l:to
    call ui#OpenMarkdownDrawer()
  endif
endfunction

function! Increase() 
  let l:l =  GoTo()
  let hCount = matchend(getline(l:l), '\m\C^#\+')
  if hCount < 6
    execute "normal! I#"
  endif
  call ui#OpenMarkdownDrawer()
endfunction

function! Decrease() 
  let l:l =  GoTo()
  let hCount = matchend(getline(l:l), '\m\C^#\+')
  if hCount > 0
    execute "s/^#//"
  endif
  call ui#OpenMarkdownDrawer()
endfunction
