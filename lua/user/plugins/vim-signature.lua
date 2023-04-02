return function()
  vim.cmd([[
    let g:SignatureForceRemoveGlobal = 1
    let g:SignatureUnconditionallyRecycleMarks = 1
    let g:SignatureErrorIfNoAvailableMarks = 0
    let g:SignaturePurgeConfirmation = 0
    let g:SignatureMarkTextHLDynamic = 1
    let g:SignatureMarkerTextHLDynamic = 1
    let g:SignatureIncludeMarks = 'abcdefghijkloqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    let g:SignatureIncludeMarkers = repeat('⚐', 10)
  ]])
end
