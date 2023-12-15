local TelescopeNodua = require("nodua")
return require("telescope").register_extension({
  exports = {
    nodua = TelescopeNodua.init,
  },
})
