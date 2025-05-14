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
