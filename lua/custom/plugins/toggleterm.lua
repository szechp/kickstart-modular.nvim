return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = '<C-x>',
      direction = 'horizontal',
    },
    keys = {
      {
        '<leader>gg',
        function()
          local Terminal = require('toggleterm.terminal').Terminal
          local lazygit = Terminal:new { cmd = 'lazygit', hidden = true, direction = 'float' }
          lazygit:toggle()
        end,
        desc = 'Lazy[g]it',
      },
      {
        '<C-`>',
        function()
          require('toggleterm').toggle()
        end,
        desc = 'Toggle Terminal',
        mode = { 'n', 't' },
      },
    },
  },
}
