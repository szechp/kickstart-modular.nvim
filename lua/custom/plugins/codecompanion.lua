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
