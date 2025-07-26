return {
  "athar-qadri/weather.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    local weather = require "weather"
    weather:setup {
      settings = {
        update_interval = 60 * 10 * 1000,
        minimum_magnitude = 5,
        location = { lat = 34.0787, lon = 74.7659 },
        temperature_unit = "celsius",
      },
    }
    require("weather.notify").start()
  end,
}
