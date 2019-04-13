### markdown-drawer - Beta
Simplify navigation in large markdown files.

### Demo

![Markdrawer Demo](https://github.com/scuilion/markdown-drawer/raw/master/demo.gif)

### Keys Mappings
* `o` navigate to header in file.
* `D` mark section for cut (no effect till paste).
* `p` paste previously marked section below current.
* `+` increase header size (removes `#`).
* `-` decrease header size (adds `#`).

### Basic Options
```vim
let g:markdrawer_prefix = " " 
let g:markdrawer_goto = "o"
let g:markdrawerDelete = "D"
let g:markdrawer_width = "25"
let g:markdrawer_paste_below = "p"
let g:markdrawer_increase = "+"
let g:markdrawer_decrease = "-"
let g:markdrawer_to_delete_color = "Red"
```

### Effect Drawer Appearance
```vim
let g:markdrawer_drawer_max_levels = 4 " max levels to display
let g:markdrawer_toc = 'index' " displays as a TOC
let g:markdrawer_toc = 'full_index' " displays as a TOC, no index reset
```

### Mapping Recommendations
Map key to open drawer:
```
nnoremap <Leader>md :MarkDrawer<cr>
```

### Commands

* `:MarkDrawer` activate plugin
* `:MarkDrawerLevelSet 3` set the max level to display

### License
MIT
