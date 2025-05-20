-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'open diagnostic [q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ my custom stuff ]]
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function(args)
    local bufnr = args.buf
    -- Wait for the yaml-language-server to start
    local clients = vim.lsp.get_clients({ name = 'yamlls', bufnr = bufnr })
    if #clients > 0 then
      -- If the server is already running, call init()
      require('custom.yaml-k8s-crds').init(bufnr)
    else
      -- If the server is not running, wait for it to start
      vim.api.nvim_create_autocmd('LspAttach', {
        once = true,
        buffer = bufnr,
        callback = function(lsp_args)
          local client = vim.lsp.get_client_by_id(lsp_args.data.client_id)
          if client and client.name == 'yamlls' then
            require('custom.yaml-k8s-crds').init(bufnr)
          end
        end,
      })
    end
  end,
})

vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

vim.api.nvim_set_keymap("x", "<S-Up>", "k", { noremap = true, silent = true, desc = "Extend visual selection up" })
vim.api.nvim_set_keymap("x", "<S-Down>", "j", { noremap = true, silent = true, desc = "Extend visual selection down" })
vim.api.nvim_set_keymap( "n", "<S-Up>", "<Esc>Vk", { noremap = true, silent = true, desc = "Start visual selection and move up" })
vim.api.nvim_set_keymap( "n", "<S-Down>", "<Esc>Vj", { noremap = true, silent = true, desc = "Start visual selection and move down" })
vim.api.nvim_set_keymap( "n", "<S-Left>", "v", { noremap = true, silent = true, desc = "Enter visual mode and select left" })
vim.api.nvim_set_keymap( "n", "<S-Right>", "v", { noremap = true, silent = true, desc = "Enter visual mode and select right" })

vim.api.nvim_set_keymap("i", "<C-A>", "<HOME>", { noremap = true, silent = true, desc = "Jump to first char in line" })
vim.api.nvim_set_keymap("i", "<C-E>", "<END>", { noremap = true, silent = true, desc = "Jump to last char in line" })

vim.api.nvim_set_keymap("n", "<C-Left>", "<C-w>h", { noremap = true, silent = true, desc = "Move to left split" })
vim.api.nvim_set_keymap("n", "<C-Right>", "<C-w>l", { noremap = true, silent = true, desc = "Move to right split" })

vim.api.nvim_set_keymap("n", "dx", '<Cmd>normal "_dd<CR>', { noremap = true, silent = true, desc = "Delete line without yanking" })
vim.api.nvim_set_keymap("v", "x", '"_d', { noremap = true, silent = true, desc = "Delete selection without yanking" })

-- close neotree when opening debug
-- vim.keymap.set('n', "<leader>du", function() vim.cmd.Neotree('toggle') require("dapui").toggle({ }) end)
-- vim.keymap.set('n', "<leader>dc", function() vim.cmd.Neotree('toggle')  require("dap").continue() end)

vim.keymap.set('n', '<leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify('Wrap: ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
end, { desc = 'Toggle Line Wrap' })

vim.keymap.set('n', '<leader>bd', function()
  vim.cmd('bdelete')
end, { desc = 'Delete Buffer' })

-- vim: ts=2 sts=2 sw=2 et
