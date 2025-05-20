return
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    event = "VeryLazy",
    keys = {
      { '<M-Up>', function() require('mini.move').move_selection 'up' end, mode = 'x', desc = 'MiniMove selection up' },
      { '<M-Down>', function() require('mini.move').move_selection 'down' end, mode = 'x', desc = 'MiniMove selection down' },
      { '<M-Left>', function() require('mini.move').move_selection 'left' end, mode = 'x', desc = 'MiniMove selection left' },
      { '<M-Right>', function() require('mini.move').move_selection 'right' end, mode = 'x', desc = 'MiniMove selection right' },
      { '<M-Up>', function() require('mini.move').move_line 'up' end, mode = 'n', desc = 'MiniMove line up' },
      { '<M-Down>', function() require('mini.move').move_line 'down' end, mode = 'n', desc = 'MiniMove line down' },
      { '<M-Left>', function() require('mini.move').move_line 'left' end, mode = 'n', desc = 'MiniMove line left' },
      { '<M-Right>', function() require('mini.move').move_line 'right' end, mode = 'n', desc = 'MiniMove line right' },
    },
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }
      require('mini.jump2d').setup()
      require('mini.jump').setup()
      require('mini.icons').setup()
      require('mini.pairs').setup()
      require('mini.indentscope').setup({
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
      })
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup {
        mappings = {
          add = 'gsa',
          delete = 'gsd',
          find = 'gsf',
          find_left = 'gsF',
          highlight = 'gsh',
          replace = 'gsr',
          update_n_lines = 'gsn',
        },
      }

      require('mini.bufremove').setup()
      require('mini.move').setup {
        {
          -- Options which control moving behavior
          options = {
            -- Automatically reindent selection during linewise vertical move
            reindent_linewise = true,
          },
        },
      }

      vim.keymap.set('n', '<leader>bd', function()
        require('mini.bufremove').delete(0, false)
      end, { desc = 'Delete Buffer' })
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  }
-- vim: ts=2 sts=2 sw=2 et
