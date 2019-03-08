" Vim BlockDiff-Plugin
"
" Author: Timo Teifel
" Email: timo dot teifel at teifel dot net
" Version: 1.1
" Date: 23 Oct 2007
" Licence: GPL v2.0
"
" Usage:
"   - Select first block
"   - Depending on the configuration, select:
"       - Menu Tools->BlockDiff-> This\ is\ Block\ 1
"       - Popup-Menu    -> This\ is\ Block\ 1
"       - :BlockDiff1
"       - ,d1
"   - select second block (may be in another file, but in the same
"     Vim window)
"       - Menu Tools->BlockDiff-> This\ is\ Block\ 2,\ start\ diff
"       - Popup-Menu    -> This\ is\ Block\ 2,\ start\ diff
"       - :BlockDiff2
"       - ,d2
"   - Script opens a new tab, splits it and shows the diff between
"     the two blocks.
"   - Close the tab when done
"
" History:
"   V1.0: Initial upload
"   V1.1: Added commands and inclusion guard, Thanks to Ingo Karkat


" Avoid installing twice or when in compatible mode
if exists('g:loaded_blockdiff') || (v:version < 700)
  "finish
endif
let g:loaded_blockdiff = 1


let s:save_cpo = &cpo
set cpo&vim

" ---------- Configuration ----------------------------------------------------
" uncomment one or more of these blocks:


" Create menu entry:
    "vmenu 40.352.10 &Tools.Bloc&kDiff.This\ is\ Block\ &1 :call BlockDiff_GetBlock1()<CR>
    "vmenu 40.352.20 &Tools.Bloc&kDiff.This\ is\ Block\ &2,\ start\ diff :call BlockDiff_GetBlock2()<CR>
    "vmenu 40.352.30 &Tools.Bloc&kDiff.This\ is\ Block\ &2,\ start\ diff :call BlockDiff_GetBlock2_and_DiffExe()<CR>


" Create popup-menu-entry:
    "vmenu PopUp.BlockDiff.This\ is\ Block\ 1 :call BlockDiff_GetBlock1()<CR>
    "vmenu PopUp.BlockDiff.This\ is\ Block\ 2,\ start\ diff :call BlockDiff_GetBlock2()<CR>
    "vmenu PopUp.BlockDiff.This\ is\ Block\ 2,\ start\ diff :call BlockDiff_GetBlock2_and_DiffExe()<CR>

" Shortcuts
    "vmap ,d1 :call BlockDiff_GetBlock1()<CR>
    "vmap ,d2 :call BlockDiff_GetBlock2()<CR>
    "vmap ,d3 :call BlockDiff_GetBlock2_and_DiffExe()<CR>

" Commands
    command! -range BlockDiff1 :<line1>,<line2>call BlockDiff_GetBlock1()
    command! -range BlockDiff2 :<line1>,<line2>call BlockDiff_GetBlock2()
    command! -range BlockDiff2AndExe :<line1>,<line2>call BlockDiff_GetBlock2_and_DiffExe()

    vnoremap <leader>1 :BlockDiff1<CR>
    vnoremap <leader>2 :BlockDiff2AndExe<CR>

" ---------- Code -------------------------------------------------------------
fun! BlockDiff_GetBlock1() range
  let s:regd = @a
  " copy selected block into unnamed register
  silent! exe a:firstline . "," . a:lastline . 'yank a'
  " save block for later use in variable
  let s:block1 = @a
  " restore unnamed register
  let @a = s:regd

  echo 'BlockDiff: Block 1 got. Line:' (a:lastline - a:firstline + 1)
endfun

fun! BlockDiff_GetBlock2_and_DiffExe() range
  let s:regd = @a
  silent! exe a:firstline . "," . a:lastline . 'yank a'

  echo 'BlockDiff: Block 2 got. Line:' (a:lastline - a:firstline + 1)

  " Open new tab, paste second selected block
  tabnew
  silent! normal! "aP
  " to prevent 'No write since last change' message:
  se buftype=nowrite
  diffthis

  " vsplit left for first selected block
  leftabove vnew
  " copy first block into unnamed register & paste
  let @a = s:block1
  silent! normal! "aP
  set buftype=nowrite

  " start diff
  diffthis

  " restore unnamed register
  let @a = s:regd

  redraw	" tabが変わったので、redしないとメッセ―ジが消えてしまう。
  "echo 'BlockDiff: Block 2 got. Line:' (a:lastline - a:firstline + 1)
  echo 'BlockDiff: Diff done.'
endfun

" Block1の獲得前に、Diffを発動してしまった時のため。
let s:block1 = ''


let &cpo = s:save_cpo
unlet s:save_cpo
