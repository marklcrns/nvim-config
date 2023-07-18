return function()
  require("tint").setup({
    transforms = {
      require("tint.transforms").tint_with_threshold(-100, "#1C1C1C", 150), -- Try to tint by `-100`, but keep all colors at least `150` away from `#1C1C1C`
      require("tint.transforms").saturate(0.5),
    },
  })
end
