return {
  'EggbertFluffle/beepboop.nvim',
  opts = {
    audio_player = 'afplay',
    max_sound = 1,
    volume = 46,
    sound_map = {
      { auto_command = 'VimEnter', sound = 'tank_1990/game_start.mp3' }, -- Neovim start
      { auto_command = 'VimLeavePre', sound = 'tank_1990/game_end.mp3' }, -- Neovim quit
      -- { auto_command = 'InsertCharPre', sound = 'tank_1990/bullet_fires.mp3' }, -- Cursor movement
      -- { auto_command = 'CursorMoved', sound = 'tank_1990/tank_moving.mp3' }, -- Cursor movement

      -- { auto_command = 'LspDiagnosticsChanged', sound = 'hitting_wall.mp3' }, -- Hitting an error
      { auto_command = 'BufWritePost', sound = 'tank_1990/eating_level_up.mp3' },
      -- }, 'hitting_unbreakable_wall.mp3'-- Save: Error = wall, Success = level-up

      { auto_command = 'CursorMoved', sound = 'tank_1990/menu_selection.mp3' },
      -- { auto_command = 'UndoRedo', sound = 'tank_1990/hitting_tank_armor.mp3' }, -- Undo/Redo

      { auto_command = 'TextYankPost', sound = 'tank_1990/enemy_dies.mp3' }, -- Deleting text
      -- { auto_command = 'VisualDelete', sound = 'tank_1990/killed_big_enemy.mp3' }, -- Deleting block in visual mode

      { auto_command = 'BufDelete', sound = 'tank_1990/base_dies.mp3' }, -- Closing a buffer
      -- { auto_command = 'InsertEnter', sound = 'tank_1990/lose_protection.mp3', blocking = true }, -- Enter insert mode
      { auto_command = 'CmdlineEnter', sound = 'tank_1990/pause.mp3' }, -- Enter command mode
      -- { auto_command = 'WinScrolled', sound = 'tank_1990/score_counting.mp3', blocking = true }, -- Scroll
      { key_map = { mode = 'i', key_chord = '<leader>', blocking = false }, sound = 'tank_1990/bullet_fires.mp3' },
    },
  },
}
