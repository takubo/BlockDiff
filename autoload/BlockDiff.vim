scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0:

if !exists('g:loaded_BlockDiff') || (v:version < 700)
  finish
endif
let g:loaded_BlockDiff = 1


let s:save_cpo = &cpo
set cpo&vim


" Block1の獲得前に、Diffを発動してしまった時のため、空文字列で初期化しておく。
let s:block1 = ''
let s:filetype1 = ''


fun! BlockDiff#GetBlock1() range
  let regd = @a
  " copy selected block into 'a' register
  silent! exe a:firstline . "," . a:lastline . 'yank a'
  " save block for later use in variable
  let s:block1 = @a
  " restore 'a' register
  let @a = regd

  let s:filetype1 = &l:filetype

  echo 'BlockDiff: Block 1 got. Line:' (a:firstline) '-' (a:lastline) ' (' (a:lastline - a:firstline + 1) ')'
endfun

fun! BlockDiff#GetBlock2_and_Exe() range
  let regd = @a
  silent! exe a:firstline . "," . a:lastline . 'yank a'

  let filetype2 = &l:filetype

  echo 'BlockDiff: Block 2 got. Line:' (a:firstline) '-' (a:lastline) ' (' (a:lastline - a:firstline + 1) ')'

  " Open new tab, paste second selected block
  tabnew
  silent! normal! "aP
  " to prevent 'No write since last change' message:
  se buftype=nowrite
  let &l:filetype = filetype2
  diffthis

  " vsplit left for first selected block
  leftabove vnew
  " copy first block into unnamed register & paste
  let @a = s:block1
  silent! normal! "aP
  set buftype=nowrite
  let &l:filetype = s:filetype1

  " start diff
  diffthis

  " restore unnamed register
  let @a = regd

  redraw	" tabが変わったので、redしないとメッセ―ジが消えてしまう。
  echo 'BlockDiff: Block 2 got. Line:' (a:firstline) '-' (a:lastline) ' (' (a:lastline - a:firstline + 1) ')'
  echo 'BlockDiff: Diff done.'
endfun


let &cpo = s:save_cpo
unlet s:save_cpo
