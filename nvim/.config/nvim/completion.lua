cmp = {
  "hrsh7th/nvim-cmp",
  version = false,
  event = "InsertEnter",

  dependencies = {
    "hrsh7th/cmp-buffer"
    "hrsh7th/cmp-path"
  },

  opts = {

  }

  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts)
  end
}

return cmp
