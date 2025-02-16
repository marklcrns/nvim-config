local lz = require("user.lazy")

return lz.module({
  au = "user.common.au", ---@module "user.common.au"
  color = "user.common.color", ---@module "user.common.color"
  hl = "user.common.hl", ---@module "user.common.hl"
  loop = "user.common.loop", ---@module "user.common.loop"
  notify = "user.common.notify", ---@module "user.common.notify"
  sys = "user.common.sys", ---@module "user.common.sys"
  utils = "user.common.utils", ---@module "user.common.utils"
}, true)
