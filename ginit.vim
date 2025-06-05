cd ~

set termguicolors
set autochdir

let g:neovide_hide_mouse_when_typing = v:true
let g:neovide_input_macos_option_key_is_meta = "only_left"

let g:neovide_opacity = 0.75
let g:neovide_background_color = "#222436".printf("%x", float2nr(255 * g:neovide_opacity))

let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_animation_length = 0.1
let g:neovide_scroll_animation_length = 0.3
let g:neovide_cursor_trail_size = 0.5

let g:terminal_color_0 = "#1b1d2b"
let g:terminal_color_1 = "#ff757f"
let g:terminal_color_2 = "#c3e88d"
let g:terminal_color_3 = "#ffc777"
let g:terminal_color_4 = "#82aaff"
let g:terminal_color_5 = "#c099ff"
let g:terminal_color_6 = "#86e1fc"
let g:terminal_color_7 = "#828bb8"
let g:terminal_color_8 = "#444a73"
let g:terminal_color_9 = "#ff8d94"
let g:terminal_color_10 = "#c7fb6d"
let g:terminal_color_11 = "#ffd8ab"
let g:terminal_color_12 = "#9ab8ff"
let g:terminal_color_13 = "#caabff"
let g:terminal_color_14 = "#b2ebff"
let g:terminal_color_15 = "#c8d3f5"