local wk = require("which-key")

wk.register({
  f = {
    name = "+file-manager",
    d = {
      name = "+finder",
      g = {
        name = "+git",
      },
    },
  },
}, { prefix = "<leader>" })
