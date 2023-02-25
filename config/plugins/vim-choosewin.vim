let g:choosewin_overlay_enable = 0
let g:choosewin_overlay_clear_multibyte = 1

" tmux-like overlay color
let g:choosewin_color_overlay = {
      \ 'gui': ['DodgerBlue3', 'DodgerBlue3'],
      \ 'cterm': [25, 25]
      \ }
let g:choosewin_color_overlay_current = {
      \ 'gui': ['firebrick1', 'firebrick1'],
      \ 'cterm': [124, 124]
      \ }

let g:choosewin_blink_on_land      = 0 " don't blink at land
let g:choosewin_tabline_replace    = 1 " replace tabline
let g:choosewin_statusline_replace = 1 " don't replace statusline
