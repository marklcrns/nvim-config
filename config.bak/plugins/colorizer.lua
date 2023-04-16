
DEFAULT_OPTIONS = {
  names    = true;         -- "Name" codes like Blue
  RGB      = true;         -- #RGB hex codes
  RRGGBB   = true;         -- #RRGGBB hex codes
  RRGGBBAA = false;         -- #RRGGBBAA hex codes
  rgb_fn   = false;        -- CSS rgb() and rgba() functions
  hsl_fn   = false;        -- CSS hsl() and hsla() functions
  -- css      = false;        -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
  -- css_fn   = false;        -- Enable all CSS *functions*: rgb_fn, hsl_fn
  -- Available modes: foreground, background
  mode     = 'background'; -- Set the display mode.
}

require 'colorizer'.setup {
  'javascriptreact';
  javascript = {
    rgb_fn = true;
    RRGGBBAA = true;
  };
  java = {
    rgb_fn = true;
    RRGGBBAA = true;
  };
  css = {
    rgb_fn = true;
  };
  scss = {
    rgb_fn = true;
  };
  sass = {
    rgb_fn = true;
  };
  html = {
    RGB = false;
    RRGGBB = false;
  };
  vim = {
    names = false;
  }
}
