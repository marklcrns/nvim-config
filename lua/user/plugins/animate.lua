return function()
  vim.cmd([[
    let g:animate#duration = 100.0
    let g:animate#easing_func = 'animate#ease_out_cubic'
  ]])
end
