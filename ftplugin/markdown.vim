" MarkdownDrawer

let s:drawerName = "__Markdown_Drawer__"
let s:outline = []
let s:file = ""
let s:is = 0

function! OpenMarkdownDrawer()
  let s:file = bufname("%")

  write

  let s:outline = MarkdownLevel()

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

function! _IsFenced(line)
  let fen = matchstr(a:line, '^\s*`\{3}')
  if !empty(fen) && s:is == 0
    let s:is = 1
  elseif !empty(fen) && s:is == 1
    let s:is = 0
  endif
  return s:is
endfunction

function! MarkdownLevel()
  let outline = []
  let pat = '^#\+'
  let numOfLines = line('$')
  let i = 1
  while i <= numOfLines
    let line = getline(i)
    if _IsFenced(line) == 0
      let divide = matchend(line, pat)
      if divide > 0
        call add(outline, {'fileLineNum': i, 'active': 0, 'header':  _HeaderName(line, divide) })
      endif
    endif
    let i += 1
  endwhile

  let currline = line('.')
  let i = len(outline) - 1
  while i > -1
    if currline >= outline[i].fileLineNum
      let outline[i].active = 1
      let i = -1
    endif
    let i -= 1
  endwhile
  return outline
endfunction

function! _HeaderName(line, divide)
  let h = strcharpart(a:line, a:divide + 1)
  if match('^\s+$', h) >= 0
    let h = '<no header>'
  endif
  return repeat(' ', a:divide - 1) . h
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

noremap <buffer> <localleader>r :call OpenMarkdownDrawer()<cr>
