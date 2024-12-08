return {
  'robitx/gp.nvim',
  keys = {
    -- VISUAL mode mappings
    {
      '<C-g><C-t>',
      ":<C-u>'<,'>GpChatNew tabnew<cr>",
      desc = 'Visual Chat New tabnew',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    {
      '<C-g><C-v>',
      ":<C-u>'<,'>GpChatNew vsplit<cr>",
      desc = 'Visual Chat New vsplit',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    {
      '<C-g><C-x>',
      ":<C-u>'<,'>GpChatNew split<cr>",
      desc = 'Visual Chat New split',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    { '<C-g>a', ":<C-u>'<,'>GpAppend<cr>", desc = 'Visual Append (after)', nowait = true, remap = false, mode = 'v' },
    {
      '<C-g>b',
      ":<C-u>'<,'>GpPrepend<cr>",
      desc = 'Visual Prepend (before)',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    { '<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", desc = 'Visual Chat New', nowait = true, remap = false, mode = 'v' },
    { '<C-g>g', group = 'generate into new ..', nowait = true, remap = false, mode = 'v' },
    { '<C-g>ge', ":<C-u>'<,'>GpEnew<cr>", desc = 'Visual GpEnew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>gn', ":<C-u>'<,'>GpNew<cr>", desc = 'Visual GpNew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>gp', ":<C-u>'<,'>GpPopup<cr>", desc = 'Visual Popup', nowait = true, remap = false, mode = 'v' },
    { '<C-g>gt', ":<C-u>'<,'>GpTabnew<cr>", desc = 'Visual GpTabnew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>gv', ":<C-u>'<,'>GpVnew<cr>", desc = 'Visual GpVnew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>i', ":<C-u>'<,'>GpImplement<cr>", desc = 'Implement selection', nowait = true, remap = false, mode = 'v' },
    { '<C-g>n', '<cmd>GpNextAgent<cr>', desc = 'Next Agent', nowait = true, remap = false, mode = 'v' },
    { '<C-g>p', ":<C-u>'<,'>GpChatPaste<cr>", desc = 'Visual Chat Paste', nowait = true, remap = false, mode = 'v' },
    { '<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", desc = 'Visual Rewrite', nowait = true, remap = false, mode = 'v' },
    { '<C-g>s', '<cmd>GpStop<cr>', desc = 'GpStop', nowait = true, remap = false, mode = 'v' },
    { '<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", desc = 'Visual Toggle Chat', nowait = true, remap = false, mode = 'v' },
    { '<C-g>w', group = 'Whisper', nowait = true, remap = false, mode = 'v' },
    {
      '<C-g>wa',
      ":<C-u>'<,'>GpWhisperAppend<cr>",
      desc = 'Whisper Append (after)',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    {
      '<C-g>wb',
      ":<C-u>'<,'>GpWhisperPrepend<cr>",
      desc = 'Whisper Prepend (before)',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    { '<C-g>we', ":<C-u>'<,'>GpWhisperEnew<cr>", desc = 'Whisper Enew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>wn', ":<C-u>'<,'>GpWhisperNew<cr>", desc = 'Whisper New', nowait = true, remap = false, mode = 'v' },
    { '<C-g>wp', ":<C-u>'<,'>GpWhisperPopup<cr>", desc = 'Whisper Popup', nowait = true, remap = false, mode = 'v' },
    {
      '<C-g>wr',
      ":<C-u>'<,'>GpWhisperRewrite<cr>",
      desc = 'Whisper Rewrite',
      nowait = true,
      remap = false,
      mode = 'v',
    },
    { '<C-g>wt', ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = 'Whisper Tabnew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>wv', ":<C-u>'<,'>GpWhisperVnew<cr>", desc = 'Whisper Vnew', nowait = true, remap = false, mode = 'v' },
    { '<C-g>ww', ":<C-u>'<,'>GpWhisper<cr>", desc = 'Whisper', nowait = true, remap = false, mode = 'v' },
    { '<C-g>x', ":<C-u>'<,'>GpContext<cr>", desc = 'Visual GpContext', nowait = true, remap = false, mode = 'v' },

    -- NORMAL mode mappings
    { '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', desc = 'New Chat tabnew', nowait = true, remap = false },
    { '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', desc = 'New Chat vsplit', nowait = true, remap = false },
    { '<C-g><C-x>', '<cmd>GpChatNew split<cr>', desc = 'New Chat split', nowait = true, remap = false },
    { '<C-g>a', '<cmd>GpAppend<cr>', desc = 'Append (after)', nowait = true, remap = false },
    { '<C-g>b', '<cmd>GpPrepend<cr>', desc = 'Prepend (before)', nowait = true, remap = false },
    { '<C-g>c', '<cmd>GpChatNew<cr>', desc = 'New Chat', nowait = true, remap = false },
    { '<C-g>f', '<cmd>GpChatFinder<cr>', desc = 'Chat Finder', nowait = true, remap = false },
    { '<C-g>g', group = 'generate into new ..', nowait = true, remap = false },
    { '<C-g>ge', '<cmd>GpEnew<cr>', desc = 'GpEnew', nowait = true, remap = false },
    { '<C-g>gn', '<cmd>GpNew<cr>', desc = 'GpNew', nowait = true, remap = false },
    { '<C-g>gp', '<cmd>GpPopup<cr>', desc = 'Popup', nowait = true, remap = false },
    { '<C-g>gt', '<cmd>GpTabnew<cr>', desc = 'GpTabnew', nowait = true, remap = false },
    { '<C-g>gv', '<cmd>GpVnew<cr>', desc = 'GpVnew', nowait = true, remap = false },
    { '<C-g>n', '<cmd>GpNextAgent<cr>', desc = 'Next Agent', nowait = true, remap = false },
    { '<C-g>r', '<cmd>GpRewrite<cr>', desc = 'Inline Rewrite', nowait = true, remap = false },
    { '<C-g>s', '<cmd>GpStop<cr>', desc = 'GpStop', nowait = true, remap = false },
    { '<C-g>t', '<cmd>GpChatToggle<cr>', desc = 'Toggle Chat', nowait = true, remap = false },
    { '<C-g>w', group = 'Whisper', nowait = true, remap = false },
    { '<C-g>wa', '<cmd>GpWhisperAppend<cr>', desc = 'Whisper Append (after)', nowait = true, remap = false },
    { '<C-g>wb', '<cmd>GpWhisperPrepend<cr>', desc = 'Whisper Prepend (before)', nowait = true, remap = false },
    { '<C-g>we', '<cmd>GpWhisperEnew<cr>', desc = 'Whisper Enew', nowait = true, remap = false },
    { '<C-g>wn', '<cmd>GpWhisperNew<cr>', desc = 'Whisper New', nowait = true, remap = false },
    { '<C-g>wp', '<cmd>GpWhisperPopup<cr>', desc = 'Whisper Popup', nowait = true, remap = false },
    { '<C-g>wr', '<cmd>GpWhisperRewrite<cr>', desc = 'Whisper Inline Rewrite', nowait = true, remap = false },
    { '<C-g>wt', '<cmd>GpWhisperTabnew<cr>', desc = 'Whisper Tabnew', nowait = true, remap = false },
    { '<C-g>wv', '<cmd>GpWhisperVnew<cr>', desc = 'Whisper Vnew', nowait = true, remap = false },
    { '<C-g>ww', '<cmd>GpWhisper<cr>', desc = 'Whisper', nowait = true, remap = false },
    { '<C-g>x', '<cmd>GpContext<cr>', desc = 'Toggle GpContext', nowait = true, remap = false },

    -- INSERT mode mappings
    { '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', desc = 'New Chat tabnew', nowait = true, remap = false, mode = 'i' },
    { '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', desc = 'New Chat vsplit', nowait = true, remap = false, mode = 'i' },
    { '<C-g><C-x>', '<cmd>GpChatNew split<cr>', desc = 'New Chat split', nowait = true, remap = false, mode = 'i' },
    { '<C-g>a', '<cmd>GpAppend<cr>', desc = 'Append (after)', nowait = true, remap = false, mode = 'i' },
    { '<C-g>b', '<cmd>GpPrepend<cr>', desc = 'Prepend (before)', nowait = true, remap = false, mode = 'i' },
    { '<C-g>c', '<cmd>GpChatNew<cr>', desc = 'New Chat', nowait = true, remap = false, mode = 'i' },
    { '<C-g>f', '<cmd>GpChatFinder<cr>', desc = 'Chat Finder', nowait = true, remap = false, mode = 'i' },
    { '<C-g>g', group = 'generate into new ..', nowait = true, remap = false, mode = 'i' },
    { '<C-g>ge', '<cmd>GpEnew<cr>', desc = 'GpEnew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>gn', '<cmd>GpNew<cr>', desc = 'GpNew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>gp', '<cmd>GpPopup<cr>', desc = 'Popup', nowait = true, remap = false, mode = 'i' },
    { '<C-g>gt', '<cmd>GpTabnew<cr>', desc = 'GpTabnew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>gv', '<cmd>GpVnew<cr>', desc = 'GpVnew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>n', '<cmd>GpNextAgent<cr>', desc = 'Next Agent', nowait = true, remap = false, mode = 'i' },
    { '<C-g>r', '<cmd>GpRewrite<cr>', desc = 'Inline Rewrite', nowait = true, remap = false, mode = 'i' },
    { '<C-g>s', '<cmd>GpStop<cr>', desc = 'GpStop', nowait = true, remap = false, mode = 'i' },
    { '<C-g>t', '<cmd>GpChatToggle<cr>', desc = 'Toggle Chat', nowait = true, remap = false, mode = 'i' },
    { '<C-g>w', group = 'Whisper', nowait = true, remap = false, mode = 'i' },
    {
      '<C-g>wa',
      '<cmd>GpWhisperAppend<cr>',
      desc = 'Whisper Append (after)',
      nowait = true,
      remap = false,
      mode = 'i',
    },
    {
      '<C-g>wb',
      '<cmd>GpWhisperPrepend<cr>',
      desc = 'Whisper Prepend (before)',
      nowait = true,
      remap = false,
      mode = 'i',
    },
    { '<C-g>we', '<cmd>GpWhisperEnew<cr>', desc = 'Whisper Enew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>wn', '<cmd>GpWhisperNew<cr>', desc = 'Whisper New', nowait = true, remap = false, mode = 'i' },
    { '<C-g>wp', '<cmd>GpWhisperPopup<cr>', desc = 'Whisper Popup', nowait = true, remap = false, mode = 'i' },
    {
      '<C-g>wr',
      '<cmd>GpWhisperRewrite<cr>',
      desc = 'Whisper Inline Rewrite',
      nowait = true,
      remap = false,
      mode = 'i',
    },
    { '<C-g>wt', '<cmd>GpWhisperTabnew<cr>', desc = 'Whisper Tabnew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>wv', '<cmd>GpWhisperVnew<cr>', desc = 'Whisper Vnew', nowait = true, remap = false, mode = 'i' },
    { '<C-g>ww', '<cmd>GpWhisper<cr>', desc = 'Whisper', nowait = true, remap = false, mode = 'i' },
    { '<C-g>x', '<cmd>GpContext<cr>', desc = 'Toggle GpContext', nowait = true, remap = false, mode = 'i' },
  },
  config = function()
    require('gp').setup {
      -- openai_api_key = { 'cat', os.getenv 'HOME' .. '/.openai_api_key' },
      log_sensitive = true,
      providers = {
        openai = {
          secret = vim.fn.system('cat ' .. os.getenv 'HOME' .. '/.openai_api_key'):gsub('%s+$', ''),
        },
        anthropic = {
          disable = false,
          secret = vim.fn.system('cat ' .. os.getenv 'HOME' .. '/.anthropic_api_key'):gsub('%s+$', ''),
        },
      },
      agents = {
        {
          name = 'ChatGPT4o-mini',
          chat = false,
          command = true,
          model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
          system_prompt = require('gp.defaults').chat_system_prompt,
        },
        {
          name = 'ChatGPT4o',
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = 'gpt-4o',
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = 'You are a general AI assistant.\n\n'
            .. 'The user provided the additional info about how they would like you to respond:\n\n'
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. '- Ask question if you need clarification to provide better answer.\n'
            .. '- Think deeply and carefully from first principles step by step.\n'
            .. '- Zoom out first to see the big picture and then zoom in to details.\n'
            .. '- Use Socratic method to improve your thinking and coding skills.\n'
            .. '- Try not to repeat previously presented answers.\n'
            .. '- Do not be sorry if you get things wrong its ok.\n',
        },
        {
          provider = 'anthropic',
          name = 'ChatClaude-3-5-Sonnet',
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = 'claude-3-5-sonnet-20241022', temperature = 0.8, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = 'You are a general AI assistant.\n\n'
            .. 'The user provided the additional info about how they would like you to respond:\n\n'
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. '- Ask question if you need clarification to provide better answer.\n'
            .. '- Think deeply and carefully from first principles step by step.\n'
            .. '- Zoom out first to see the big picture and then zoom in to details.\n'
            .. '- Use Socratic method to improve your thinking and coding skills.\n'
            .. '- Try not to repeat what was previously said.\n'
            .. '- Do not be sorry if you get things wrong its ok.\n',
        },
        {
          name = 'ChatClaude-3-Haiku',
          disable = true,
        },
      },
      hooks = {
        -- example of adding command which writes unit tests for the selected code
        UnitTests = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please respond by writing a corresponding unit tests for the code above following'
            .. 'the best practices and favor less mocking if possible'
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
        end,
        -- example of adding command which explains the selected code
        Explain = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please respond by explaining the code above.'
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
        end,
        -- example of usig enew as a function specifying type for the new buffer
        CodeReview = function(gp, params)
          local template = 'I have the following code from {{filename}}:\n\n'
            .. '```{{filetype}}\n{{selection}}\n```\n\n'
            .. 'Please analyze for code smells and suggest improvements.'
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.enew 'markdown', nil, agent.model, template, agent.system_prompt)
        end,
      },
    }
  end,
}
