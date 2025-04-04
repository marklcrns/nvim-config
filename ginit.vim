" Gui Fonts
let g:guifontsize = 14

if has('win32') || has('win64') " -- Windows Fonts
  let g:guifont = 'MonoLisa\ Nerd\ Font'
  " let g:guifont = 'Source\ Code\ Pro\ iCursive\ S12'
  " let g:guifont = 'OperatorMono\ Nerd\ Font'
  " let g:guifont = 'VictorMono\ Nerd\ Font'
elseif has('mac') " -- MacOS Fonts
  let g:guifont = 'SauceCodePro\ Nerd\ Font\ Mono'
endif
