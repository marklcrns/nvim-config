let g:vimspector_code_minwidth = 90
let g:vimspector_terminal_maxwidth = 75
let g:vimspector_terminal_minwidth = 20

" Sample C++ program in bin/main ran by gdb with args: `V -a "-2 4 ^"`
" Store the code below in `.vimspector.json` in project working directory.
" Ref:
" https://puremourning.github.io/vimspector-web/demo-setup.html
" https://stackoverflow.com/a/60674780
" {
"   "configurations": {
"     "Launch": {
"       "adapter": "vscode-cpptools",
"       "configuration": {
"         "type": "cppdbg",
"         "request": "launch",
"         "program": "${workspaceRoot}/bin/main",
"         "args": [
"           "-V",
"           "-a", "-2 4 ^" ],
"         "cwd": "${workspaceRoot}/src/",
"         "externalConsole": true,
"         "logging": {
"           "engineLogging": false
"         },
"         "stopOnEntry": true,
"         "stopAtEntry": true,
"         "MIMode": "gdb"
"       }
"     }
"   }
" }
