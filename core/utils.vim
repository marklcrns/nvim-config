" Used for caching config values to data directory
function! g:CacheToDataDir(filename, data)
  let data_dir = stdpath('data') . '/cache'
  if !isdirectory(data_dir)
    call mkdir(data_dir, 'p')
  endif
  let data_file = data_dir . '/' . a:filename

  " Convert to string if it is boolean
  if type(a:data) == v:t_bool
    let data = a:data ? 'true' : 'false'
    call writefile([data], data_file)
    return
  endif

  call writefile([data], data_file)
endfunction

" Used for reading cached config values from data directory
function! g:ReadCacheFromDataDir(filename, default)
  let data_dir = stdpath('data') . '/cache'
  if !isdirectory(data_dir)
    return
  endif

  let data_file = data_dir . '/' . a:filename
  if filereadable(data_file)
    let data = readfile(data_file)
    if len(data) > 0
      " Interpret the first line as boolean if it is either 'true' or 'false'
      if data[0] == 'true'
        return v:true
      elseif data[0] == 'false'
        return v:false
      endif

      return data[0]
    endif
  endif

  return a:default
endfunction

