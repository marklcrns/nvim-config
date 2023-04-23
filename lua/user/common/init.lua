local lazy = require("user.lazy")

return {
  au = lazy.require("user.common.au"), ---@module "user.common.au"
  color = lazy.require("user.common.color"), ---@module "user.common.color"
  hl = lazy.require("user.common.hl"), ---@module "user.common.hl"
  notify = lazy.require("user.common.notify"), ---@module "user.common.notify"
  sys = lazy.require("user.common.sys"), ---@module "user.common.sys"
  utils = lazy.require("user.common.utils"), ---@module "user.common.utils"
  mapper = lazy.require("user.common.keymapper"), ---@module "user.common.keymapper"
  loop = lazy.require("user.common.loop"), ---@module "user.common.loop"
}
