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
        require('mini.base16').setup({
          palette = {
            base00 = "#16181a",
            base01 = "#1e2124",
            base02 = "#3c4048",
            base03 = "#7b8496",
            base04 = "#7b8496",
            base05 = "#ffffff",
            base06 = "#16181a",
            base07 = "#ffffff",
            base08 = "#ff6e5e",
            base09 = "#ffbd5e",
            base0A = "#f1ff5e",
            base0B = "#5eff6c",
            base0C = "#5ef1ff",
            base0D = "#5ea1ff",
            base0E = "#bd5eff",
            base0F = "#ff5ef1",
          },
          use_cterm = true,
          plugins = {
            default = false,
            ['echasnovski/mini.nvim'] = true,
          },
        })
      require('mini.jump2d').setup { mappings = { start_jumping = '' } }
      local function make_fFtT_keymap(key, extra_opts)
        local opts = vim.tbl_deep_extend('force', { allowed_lines = { blank = false, fold = false } }, extra_opts)
        opts.hooks = opts.hooks or {}

        opts.hooks.before_start = function()
          local input = vim.fn.getcharstr()
          --stylua: ignore
          if input == nil then
            opts.spotter = function() return {} end
          else
            local pattern = vim.pesc(input)
            opts.spotter = MiniJump2d.gen_pattern_spotter(pattern)
          end
        end

        -- Using `<Cmd>...<CR>` enables dot-repeat in Operator-pending mode
        _G.jump2dfFtT_opts = _G.jump2dfFtT_opts or {}
        _G.jump2dfFtT_opts[key] = opts
        local command = string.format('<Cmd>lua MiniJump2d.start(_G.jump2dfFtT_opts.%s)<CR>', key)

        vim.api.nvim_set_keymap('n', key, command, {})
        vim.api.nvim_set_keymap('v', key, command, {})
        vim.api.nvim_set_keymap('o', key, command, {})
      end

      make_fFtT_keymap('f', { allowed_lines = { cursor_before = false } })
      make_fFtT_keymap('F', { allowed_lines = { cursor_after = false } })
      make_fFtT_keymap('t', {
        allowed_lines = { cursor_before = false },
        hooks = { after_jump = function() vim.api.nvim_input('<Left>') end },
      })
      make_fFtT_keymap('T', {
        allowed_lines = { cursor_after = false },
        hooks = { after_jump = function() vim.api.nvim_input('<Right>') end },
      })

      require('mini.icons').setup()
      require('mini.statusline').setup()
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
