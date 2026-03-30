local wezterm = require("wezterm")
wezterm.on("gui-startup", function(cmd)
  wezterm.plugin.update_all()
end)
