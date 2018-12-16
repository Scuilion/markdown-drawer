let s:drawerName = "__Markdown_Drawer__"
let s:outline = []
let s:file = ""

function! ui#OpenMarkdownDrawer()
  let s:file = bufname("%")

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

  exec 'nnoremap <buffer> <silent> o :call GoTo()<cr>'

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


