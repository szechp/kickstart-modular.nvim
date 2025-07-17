return {
  'cenk1cenk2/schema-companion.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },

  -- Clone and patch the Kubernetes schema repo during plugin install/update
  build = function()
    local schema_dir = vim.fn.stdpath 'data' .. '/k8s-json-schema'
    local all_json = schema_dir .. '/master/all.json'

    -- Clone or update the repo
    if vim.fn.isdirectory(schema_dir) == 1 then
      os.execute('cd ' .. schema_dir .. ' && git pull')
    else
      os.execute('git clone --depth 1 https://github.com/yannh/kubernetes-json-schema ' .. schema_dir)
    end

    -- Patch: replace "oneOf" with "anyOf" to allow multiple resources in multi-doc YAMLs
    local file = io.open(all_json, 'r')
    if file then
      local content = file:read '*a'
      file:close()
      if content then
        local patched = content:gsub('"oneOf"%s*:', '"anyOf":')
        local out = io.open(all_json, 'w')
        if out then
          out:write(patched)
          out:close()
        end
      end
    end
  end,

  config = function()
    local schema_dir = vim.fn.stdpath 'data' .. '/k8s-json-schema'
    local all_json_uri = 'file://' .. schema_dir .. '/master/all.json'

    -- Plugin setup: register schemas and configure Kubernetes matcher
    require('schema-companion').setup {
      schemas = {
        {
          name = 'Kubernetes (anyOf patched)',
          uri = all_json_uri,
        },
      },
      matchers = {
        require('schema-companion.matchers.kubernetes').setup {
        },
      },
    }

    -- Manual schema selection keymap using vim.ui.select (works with snacks, no telescope needed)
    vim.keymap.set('n', '<leader>sya', function()
      local schemas = require('schema-companion.schema').all()
      if not schemas or #schemas == 0 then
        return
      end

      vim.ui.select(schemas, {
        prompt = 'Select schema',
        format_item = function(item) return item.name or item.uri end,
      }, function(choice)
        if choice then
          require('schema-companion.context').schema(vim.api.nvim_get_current_buf(), {
            name = choice.name or choice.uri,
            uri = choice.uri,
          })
        end
      end)
    end, { desc = 'Apply schema manually' })
  end,
}
