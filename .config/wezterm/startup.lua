local wezterm = require("wezterm")
wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

wezterm.on("gui-startup", function(cmd)
  -- TODO: find a way to load into it the desired default WS by default

  wezterm.plugin.update_all()
end)
