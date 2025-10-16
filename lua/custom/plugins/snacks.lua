return {
  'folke/snacks.nvim',
  version = '*',
  priority = 1000,
  lazy = false,
  -- snacks.nvim is a plugin that contains a collection of QoL improvements.
  -- One of those plugins is called snacks-picker
  -- It is a fuzzy finder, inspired by Telescope, that comes with a lot of different
  -- things that it can fuzzy find! It's more than just a "file finder", it can search
  -- many different aspects of Neovim, your workspace, LSP, and more!
  --
  -- Two important keymaps to use while in a picker are:
  --  - Insert mode: <c-/>
  --  - Normal mode: ?
  --
  -- This opens a window that shows you all of the keymaps for the current
  -- Snacks picker. This is really useful to discover what nacks-picker can
  -- do as well as how to actually do it!
  -- [[ Configure Snacks Pickers ]]
  -- See `:help snacks-picker` and `:help snacks-picker-setup`
  ---@type snacks.Config
  opts = {
    lazygit = {},
    -- your configuration comes here
    -- or leave it empty to use the default settings
    dashboard = { enabled = false },

    picker = {
      win = {
        -- input window
        input = {
          keys = {
            ['H'] = { 'toggle_hidden', mode = { 'n' } },
            ['I'] = { 'toggle_ignored', mode = { 'n' } },
            ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
            ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
            ['<C-s>'] = { 'history_forward', mode = { 'i', 'n' } },
            ['<C-r>'] = { 'history_back', mode = { 'i', 'n' } },
          },
        },
      },
      sources = {
        grep = {
          hidden = true,
          ignored = true,
        },
        explorer = {

          layout = {
            preset = 'sidebar',
            -- preview = "file"
          },
          enabled = true,
          hidden = true,

          -- keymaps for snacks explorer
          -- win = {
          --   list = {
          --     keys = {
          --       ["d"] = function(source)
          --         if source:action("explorer_yank") then
          --           source:action("explorer_del")
          --         end
          --       end,
          --     },
          --   },
          -- },

          actions = {
            explorer_del = function(picker)
              local _, res = pcall(function() return vim.fn.confirm('Do you want to put files into trash?', '&Yes\n&No\n&Cancel', 1, 'Question') end)
              if res ~= 1 then
                return
              end
              for _, item in ipairs(picker:selected { fallback = true }) do
                vim.fn.jobstart('trash ' .. item.file, {
                  detach = true,
                  on_exit = function() picker:update() end,
                })
              end
            end,
          },
        },
        buffers = {
          auto_close = true,
          layout = {
            preset = 'vscode',
          },
        },
        files = {
          hidden = true, -- Show hidden files
          ignored = true,
          -- layout = { layout = { position = "top" } },
        },
      },
    },
  },

  -- See `:help snacks-pickers-sources`
  keys = {
    -- snacks picker keymaps to replace telescope
      { '<leader>sh', function() Snacks.picker.help() end, desc = '[h]elp' },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = '[k]eymaps' },
      { '<leader>.', function() Snacks.picker.files() end, desc = 'find files in [.]/' },
      { '<leader>ss', function() Snacks.picker.pickers() end, desc = '[s]elect Snacks' },
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'current [w]ord', mode = { 'n', 'x' } },
      { '<leader>/', function() Snacks.picker.grep() end, desc = 'grep (cwd)' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = '[d]iagnostics' },
      { '<leader>sp', function() Snacks.picker.resume() end, desc = 'resume [p]revious picker' },
      { '<leader>sr', function() Snacks.picker.recent() end, desc = '[r]ecent Files' },
      { '<leader><leader>', function() Snacks.picker.smart() end, desc = '[ ] smart picker' },
      { '<leader>sg', function() Snacks.picker.grep_buffers() end, desc = '[g]rep in Open Files' },
      -- Shortcut for searching your Neovim configuration files
      { '<leader>sN', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = '[N]eovim files' },
      -- other snacks keymaps
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'lazy[g]it' },
      {
        '<leader>o',
        function()
          local explorer_pickers = Snacks.picker.get { source = 'explorer' }
          for _, v in pairs(explorer_pickers) do
            v:focus()
          end
          if #explorer_pickers == 0 then
            Snacks.picker.explorer()
          end
        end,
        desc = '[o]pen explorer',
      },
      { mode = { 'n' }, '<c-`>', function() Snacks.terminal() end, { desc = 'Terminal (cwd)' } },
      { mode = { 'n' }, '<C-/>' },
      { mode = { 't' }, '<C-`>', '<cmd>close<cr>', { desc = 'Hide Terminal' } },
      { mode = { 't' }, '<C-/>' },
  },
}
