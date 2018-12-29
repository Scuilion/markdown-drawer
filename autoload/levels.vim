let s:is = 0

function! levels#MarkdownLevel()
  let outline = []
  let numOfLines = line('$')
  let i = 1
  let currline = line('.')
  while i <= numOfLines
    let line = getline(i)
    if IsFenced(line) == 0
      call Header(outline, line, i) 
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

function! HeaderName(line, divide)
  let h = strcharpart(a:line, a:divide + 1)
  if match('\m\C^\s+$', h) >= 0
    let h = '<no header>'
  endif
  return repeat(g:markdrawerPrefix, a:divide - 1) . h
endfunction

function! IsFenced(line)
  let fen = matchstr(a:line, '\m\C^\s*`\{3}')
  if !empty(fen) && s:is == 0
    let s:is = 1
  elseif !empty(fen) && s:is == 1
    let s:is = 0
  endif
  return s:is
endfunction

function! Header(outline, line, lNum) 
  let pat = '\m\C^#\+'
  let hCount = matchend(a:line, pat)
  if hCount > 0
    call add(a:outline, {'fileLineNum': a:lNum, 'active': 0, 'header':  HeaderName(a:line, hCount) })
  endif
endfunction
