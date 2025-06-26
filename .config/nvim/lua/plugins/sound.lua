return {
  'EggbertFluffle/beepboop.nvim',
  opts = {
    audio_player = 'afplay',
    max_sound = 1,
    volume = 10,
    sound_map = {
      { auto_command = 'VimEnter', sound = 'tank_1990/game_start.mp3' }, -- Neovim start
      { auto_command = 'VimLeavePre', sound = 'tank_1990/game_end.mp3' }, -- Neovim quit
      -- { auto_command = 'BufWritePost', sound = 'tank_1990/eating_level_up.mp3' },
      -- { auto_command = 'CursorMoved', sound = 'tank_1990/menu_selection.mp3' },
      { auto_command = 'TextYankPost', sound = 'tank_1990/enemy_dies.mp3' }, -- Deleting text
      { auto_command = 'RecordingLeave', sound = 'tank_1990/killed_big_enemy.mp3' }, -- Deleting block in visual mode
      { auto_command = 'BufDelete', sound = 'tank_1990/base_dies.mp3' }, -- Closing a buffer
      { auto_command = 'CmdlineEnter', sound = 'tank_1990/pause.mp3' }, -- Enter command mode
    },
  },
}
