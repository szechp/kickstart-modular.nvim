return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
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
          action_palette = {
            provider = 'snacks',
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
      }
    end,
  },
}
