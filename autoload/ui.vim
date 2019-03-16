let s:drawerName = "__Markdown_Drawer__"
let s:outline = []
let s:file = ""
let s:fileLength = 0

function! ui#OpenMarkdownDrawer()
  let s:file = expand("%:p")
  let s:fileLength = line('$')

  write

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

  setlocal readonly nomodifiable

  let l:i = 0
  let l:goto = 0
  while i < len(s:outline)
    if 1 == s:outline[i].active
      let l:goto = i + 1
    endif
    let l:i += 1
  endwhile

  execute "normal! " . l:goto . "G"
  execute 'nnoremap <buffer> <silent> '. g:markdrawerDelete . ' :call Delete()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawerPasteBelow . ' :call PasteBelow()<cr>'
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

function! GoTo()
  let l = s:outline[line('.') - 1].fileLineNum
  execute bufwinnr(s:file) . 'wincmd w'
  execute "normal! " . l . "G"
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
    write
    call ui#OpenMarkdownDrawer()
  endif
endfunction
