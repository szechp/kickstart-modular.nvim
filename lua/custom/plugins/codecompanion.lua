return {
  {
    'olimorris/codecompanion.nvim',
    keys = {
      -- Open chat window
      {
        '<leader>ac',
        function()
          local mode = vim.fn.mode()
          if mode == 'v' or mode == 'V' or mode == '' then
            -- escape visual mode, then run with '<,'> range
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)
            vim.cmd "'<,'>CodeCompanionChat"
          else
            vim.cmd 'CodeCompanionChat'
          end
        end,
        mode = { 'n', 'v' },
        desc = 'Open Code Companion Chat (contextual)',
      },
      -- Open action palette
      { '<leader>aa', '<cmd>CodeCompanionActions<cr>', desc = 'Open Code Companion Action Palette' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
      {
        'Davidyz/VectorCode',
        version = '0.6.13', -- optional, depending on whether you're on nightly or release
        build = 'pipx upgrade vectorcode', -- optional but recommended. This keeps your CLI up-to-date.
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'codecompanion' },
        keys = {
          -- Accept next word with Alt+Right
          { '<M-Right>', '<Plug>(copilot-accept-word)', mode = 'i', desc = 'Copilot Accept Word' },
          -- Accept next line with Alt+Ctrl+Right
          { '<M-C-Right>', '<Plug>(copilot-accept-line)', mode = 'i', desc = 'Copilot Accept Line' },
          -- Cycle to next suggestion with Alt+]
          { '<M-]>', '<Plug>(copilot-next)', mode = 'i', desc = 'Copilot Next Suggestion' },
          -- Cycle to previous suggestion with Alt+[
          { '<M-[>', '<Plug>(copilot-previous)', mode = 'i', desc = 'Copilot Previous Suggestion' },
          -- Dismiss suggestion
          { '<C-]>', '<Plug>(copilot-dismiss)', mode = 'i', desc = 'Copilot Dismiss Suggestion' },
          -- Request suggestion explicitly
          { '<M-\\>', '<Plug>(copilot-suggest)', mode = 'i', desc = 'Copilot Request Suggestion' },
        },
      },
    },
    config = function()
      require('codecompanion').setup {
        log_level = 'DEBUG',
        strategies = {
          chat = {
            adapter = 'copilot',
          },
        },
        display = {
          chat = {
            window = {
              -- layout = 'buffer',
            },
            action_palette = {},
          },
          action_palette = {
            provider = 'snacks',
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
        extensions = {
          vectorcode = {
            opts = {
              add_tool = true,
            },
          },
        },
      }
    end,
  },
}
