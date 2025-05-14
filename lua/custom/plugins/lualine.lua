return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('lualine').setup {
      options = {
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            -- 'neo-tree',
          },
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { {
          'filename',
          path = 1,
          fmt = function(name)
            if vim.bo.buftype == 'terminal' then
              return ''
            end
            return name
          end,
        } },
        lualine_x = {}, -- remove encoding, fileformat, etc.
        lualine_y = {}, -- only keep filetype here
        lualine_z = { 'filetype' }, -- remove location info
      },
    }
  end,
}
