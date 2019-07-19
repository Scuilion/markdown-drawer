let s:is = 0

function! levels#MarkdownLevel() abort
  let l:outline = []
  let l:i = 1
  while i <= line('$')
    let line = getline(i)
    if !IsFenced(i)
      call Header(l:outline, line, i) 
    endif
    let l:i += 1
  endwhile

  if exists('g:markdrawer_toc') 
    if g:markdrawer_toc ==# 'full_index'
      let l:c = [0, 0, 0, 0, 0, 0]
      let l:i = 0
      while i < len(l:outline)
        let l:x = l:outline[i].level - 1
        let l:c[l:x] = l:c[l:x] + 1
        let l:outline[i].index = l:c[l:x]
        let l:i += 1
      endwhile
    endif
    if g:markdrawer_toc ==# 'index'
      let l:c = [0, 0, 0, 0, 0, 0]
      let l:i = 0
      let l:prev = 0
      while i < len(l:outline)
        " if l:curr becomes less than prev, I reset that l:c[curr]
        let l:x = l:outline[i].level - 1 " this is curr
        if l:x < l:prev
          let l:c[l:prev] = 0
          let l:prev = 0
        endif
        let l:c[l:x] = l:c[l:x] + 1
        let l:outline[i].index = l:c[l:x]
        let l:prev = l:x
        let l:i += 1
      endwhile
    endif
  endif

  " TODO: Should be able to do this simply enough in the Header function
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
  let syntaxGroup = map(synstack(a:line, 1), 'synIDattr(v:val, "name")')
  for value in syntaxGroup
    if value =~# '\vmarkdown(Code|Highlight)'
        return 1
    endif
  endfor
  return 0
endfunction

" TODO: don't pass in outline
function! Header(outline, line, lNum) abort
  let l:pattern = '\v(#+)\s*(.*)'
  let l:matches = matchlist(a:line, l:pattern)

  let l:max_levels = get(g:, 'markdrawer_drawer_max_levels', 6)
  if len(l:matches) > 0 && len(l:matches[1]) <= l:max_levels
    call add(a:outline, {'fileLineNum': a:lNum, 'active': 0, 'level': len(l:matches[1]), 'header':  HeaderName(l:matches[2]) })
  endif
endfunction
