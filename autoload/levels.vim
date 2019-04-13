let s:is = 0

function! levels#MarkdownLevel() abort
  let l:outline = []
  let l:i = 1
  while i <= line('$')
    let line = getline(i)
    if IsFenced(line) == 0
      call Header(l:outline, line, i) 
    endif
    let l:i += 1
  endwhile

  let l:i = len(l:outline) - 1
  while i > -1
    if line('.') >= l:outline[i].fileLineNum
      let l:outline[i].active = 1
      let l:i = -1
    endif
    let l:i -= 1
  endwhile
  return l:outline
endfunction

function! HeaderName(line) abort
  let l:h = a:line
  if len(a:line) == 0
    let l:h = '<no header>'
  endif
  return l:h
endfunction

function! IsFenced(line) abort
  let l:fen = matchstr(a:line, '\m\C^\s*`\{3}')
  if !empty(l:fen) && s:is == 0
    let s:is = 1
  elseif !empty(l:fen) && s:is == 1
    let s:is = 0
  endif
  return s:is
endfunction

function! Header(outline, line, lNum) abort
  let l:pattern = '\v(#+)\s*(.*)'
  let l:matches = matchlist(a:line, l:pattern)

  let l:max_levels = get(g:, 'markdown_drawer_max_levels', 6)
  if len(l:matches) > 0 && len(l:matches[1]) <= l:max_levels
    call add(a:outline, {'fileLineNum': a:lNum, 'active': 0, 'level': len(l:matches[1]), 'header':  HeaderName(l:matches[2]) })
  endif
endfunction
