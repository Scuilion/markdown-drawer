let s:is = 0

function! levels#MarkdownLevel()
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

function! HeaderName(line, divide)
  let l:h = strcharpart(a:line, a:divide + 1)
  if match('\m\C^\s+$', h) >= 0
    let l:h = '<no header>'
  endif
  return repeat(g:markdrawerPrefix, a:divide - 1) . h
endfunction

function! IsFenced(line)
  let l:fen = matchstr(a:line, '\m\C^\s*`\{3}')
  if !empty(l:fen) && s:is == 0
    let s:is = 1
  elseif !empty(l:fen) && s:is == 1
    let s:is = 0
  endif
  return s:is
endfunction

function! Header(outline, line, lNum) 
  let l:hCount = matchend(a:line, '\m\C^#\+')
  let l:max_levels = get(g:, 'markdown_drawer_max_levels', 6)

  if l:hCount > 0 && l:hCount <= l:max_levels
    call add(a:outline, {'fileLineNum': a:lNum, 'active': 0, 'header':  HeaderName(a:line, l:hCount) })
  endif
endfunction
