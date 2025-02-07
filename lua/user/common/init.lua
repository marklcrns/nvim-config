local lz = require("user.lazy")

return {
  au = lz.require("user.common.au"), ---@module "user.common.au"
  color = lz.require("user.common.color"), ---@module "user.common.color"
  hl = lz.require("user.common.hl"), ---@module "user.common.hl"
  loop = lz.require("user.common.loop"), ---@module "user.common.loop"
  notify = lz.require("user.common.notify"), ---@module "user.common.notify"
  sys = lz.require("user.common.sys"), ---@module "user.common.sys"
  utils = lz.require("user.common.utils"), ---@module "user.common.utils"
}
