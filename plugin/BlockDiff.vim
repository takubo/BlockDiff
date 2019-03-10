scriptencoding utf-8
" vim:set ts=8 sts=2 sw=2 tw=0:

if exists('g:loaded_BlockDiff') || (v:version < 700)
  finish
endif
let g:loaded_BlockDiff = 1


let s:save_cpo = &cpo
set cpo&vim


command! -range BlockDiffGetBlock1       :<line1>,<line2>call BlockDiff#GetBlock1()
command! -range BlockDiffGetBlock2andExe :<line1>,<line2>call BlockDiff#GetBlock2_and_Exe()

vnoremap <silent> <Plug>(BlockDiff-GetBlock1)       :BlockDiffGetBlock1<CR>
vnoremap <silent> <Plug>(BlockDiff-GetBlock2andExe) :BlockDiffGetBlock2andExe<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
