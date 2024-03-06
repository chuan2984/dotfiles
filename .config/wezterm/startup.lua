local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local args = {}
  if cmd then
    args = cmd.args
  end

  local home = wezterm.home_dir
  
  local work_dir = home .. '/GitHub'
  local tab_one, pane_one, window = mux.spawn_window {
    workspace = 'work',
    cwd = work_dir .. '/fieldwire_api',
    args = args,
  }
  tab_one:set_title('api')
  pane_one:send_text('rake web:up\n')

  local tab_two, second_pane, _ = window:spawn_tab {
    cwd = home .. '/GitHub/fieldwire_web_app',
  }

  tab_two:set_title('web_app')
  second_pane:send_text('yarn dev_server\n')

  tab_one:activate()

  --  local editor_pane = build_pane:split {
  --  direction = 'Top',
  --  size = 0.6,
  --  cwd = project_dir,
  --}
  ---- may as well kick off a build in that pane
  --build_pane:send_text 'cargo build\n'

  local personal_dir = home .. '/.dotfiles/.config'
  local tab_three, pane, window = mux.spawn_window {
    workspace = 'personal',
    cwd = personal_dir,
    args = args
  }
  tab_three:set_title('dot')

  tab_three:set_title('dot')

  -- We want to startup in the coding workspace
  mux.set_active_workspace 'work'
end)
