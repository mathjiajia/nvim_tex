set autochdir

" Allow copy paste in neovim
nmap <D-v> "+p
imap <D-v> <C-r>+

let g:neovide_opacity = 0.8
let g:neovide_normal_opacity = 0.8

let g:neovide_floating_shadow = v:false
let g:neovide_floating_blur_amount_x = 20.0
let g:neovide_floating_blur_amount_y = 20.0

let g:neovide_hide_mouse_when_typing = v:true
let g:neovide_input_macos_option_key_is_meta = "only_left"

let g:neovide_cursor_smooth_blink = v:true
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_animation_length = 0.1
let g:neovide_scroll_animation_length = 0.3
let g:neovide_cursor_trail_size = 0.5
