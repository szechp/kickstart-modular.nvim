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
      -- https://github.com/echasnovski/mini.nvim/wiki/mini.jump2d#replace-f-f-t-t
      local function make_fftt_keymap(key, extra_opts)
        local opts = vim.tbl_deep_extend('force', { allowed_lines = { blank = false, fold = false } }, extra_opts)
        opts.hooks = opts.hooks or {}

        opts.hooks.before_start = function()
          local input = vim.fn.getcharstr()
        --stylua: ignore
        if input == nil then
          opts.spotter = function() return {} end
        else
          local pattern = vim.pesc(input)
          opts.spotter = minijump2d.gen_pattern_spotter(pattern)
        end
        end

        -- using `<cmd>...<cr>` enables dot-repeat in operator-pending mode
        _g.jump2dfftt_opts = _g.jump2dfftt_opts or {}
        _g.jump2dfftt_opts[key] = opts
        local command = string.format('<cmd>lua minijump2d.start(_g.jump2dfftt_opts.%s)<cr>', key)

        vim.api.nvim_set_keymap('n', key, command, {})
        vim.api.nvim_set_keymap('v', key, command, {})
        vim.api.nvim_set_keymap('o', key, command, {})
      end

      make_fftt_keymap('f', { allowed_lines = { cursor_before = false } })
      make_fftt_keymap('f', { allowed_lines = { cursor_after = false } })
      make_fftt_keymap('t', {
        allowed_lines = { cursor_before = false },
        hooks = {
          after_jump = function()
            vim.api.nvim_input '<left>'
          end,
        },
      })
      make_fftt_keymap('t', {
        allowed_lines = { cursor_after = false },
        hooks = {
          after_jump = function()
            vim.api.nvim_input '<right>'
          end,
        },
      })
      require('mini.icons').setup()
      require('mini.pairs').setup()
      require('mini.indentscope').setup {
        draw = {
          animation = require('mini.indentscope').gen_animation.none(),
        },
      }
      -- add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [s]urround [a]dd [i]nner [w]ord [)]paren
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
