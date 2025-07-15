return {
  'cenk1cenk2/schema-companion.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },
    keys = {
      { '<leader>sys', ':lua require("telescope").extensions.schema_companion.select_schema()<CR>', desc = 'select [s]chema' },
      { '<leader>sym', ':lua require("telescope").extensions.schema_companion.select_from_matching_schemas()<CR>', desc = 'select from [m]atching schemas' },
    },
  config = function()
    require('schema-companion').setup {
      -- if you have telescope you can register the extension
      matchers = {
        -- add your matchers
        require('schema-companion.matchers.kubernetes').setup { version = 'master' },
      },
    }
  end,
}
