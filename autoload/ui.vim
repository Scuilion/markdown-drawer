let s:drawerName = '__Markdown_Drawer__'
let s:outline = []
let s:file = ''
let s:fileLength = 0

function! ui#OpenMarkdownDrawer() abort
  let s:file = expand('%:p')
  let s:fileLength = line('$')

  let s:outline = levels#MarkdownLevel()

  " Prevent multiple versions of the Drawer
  if !ReuseWindow()
    call CreateNewWindow()
  else
    execute bufwinnr(s:drawerName) . 'wincmd w'
  endif

  " Redraw outline
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
    let l:goto = 1
  endif

  execute 'normal! ' . l:goto . 'G'
  execute 'nnoremap <buffer> <silent> '. g:markdrawerDelete . ' :call Delete()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawer_paste_below . ' :call PasteBelow()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawer_increase . ' :call Increase()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawer_decrease . ' :call Decrease()<cr>'
  execute 'nnoremap <buffer> <silent> '. g:markdrawer_goto . ' :call GoTo()<cr>'

endfunction

function! CreateNewWindow() abort
  execute 'vsplit' s:drawerName
  execute 'vertical resize '. g:markdrawer_width
  set winfixwidth
  setlocal filetype=markdrawer
  setlocal buftype=nofile
endfunction

" if the drawer is already opened
function! ReuseWindow() abort
  if bufwinnr(s:drawerName) != -1
    return 1
  endif
  return 0
endfunction

function! CreateTree() abort
  let l:list = []
  for i in s:outline
    let l:h = repeat(g:markdrawer_prefix, i.level) . i.header
    call add(l:list, l:h)
  endfor
  return l:list
endfunction

" refresh the tree after setting a new level
function! ui#MarkDrawerLevelSet(args) abort
  if a:args =~# '[^0-9]'
     echom 'Not a number: ' . a:args
     return
  endif
  let g:markdown_drawer_max_levels=a:args
  call GoTo()
  call ui#OpenMarkdownDrawer()
endfunction

" Finds the where to place cursor base off the outline 
" and returns that line number
function! GoTo() abort
  let l = s:outline[line('.') - 1].fileLineNum
  execute bufwinnr(s:file) . 'wincmd w'
  execute 'normal! ' . l . 'G'
  return l
endfunction

function! Delete() abort
  let l:i = line('.')-1
  let s:dStart = s:outline[i].fileLineNum 
  let s:dEnd = s:fileLength

  syntax clear ToDelete
  execute 'syntax match ToDelete /\%' . line('.') . 'l.*/'

  if len(s:outline) > l:i + 1
    let s:dEnd = s:outline[l:i + 1].fileLineNum - 1
  endif
endfunction

function! PasteBelow() abort
  if exists('s:dStart') && exists('s:dEnd')
    let l:to = s:fileLength
    if len(s:outline) > line('.')
      let l:to = s:outline[line('.')].fileLineNum - 1
    endif

    execute bufwinnr(s:file) . 'wincmd w'    

    " Move lines
    execute s:dStart . ',' . s:dEnd . 'm ' . l:to

    call ui#OpenMarkdownDrawer()
    syntax clear ToDelete
  endif
endfunction

function! Decrease() abort
  let l:l =  GoTo()
  if matchend(getline(l:l), '\m\C^#\+') < 6
    execute 'normal! I#'
  endif
  call ui#OpenMarkdownDrawer()
endfunction

function! Increase() abort
  let l:l =  GoTo()
  if matchend(getline(l:l), '\m\C^#\+') > 0
    execute 's/^#//'
  endif
  call ui#OpenMarkdownDrawer()
endfunction
