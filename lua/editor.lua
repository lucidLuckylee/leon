-- editor.lua
local map = vim.keymap.set

-- File tree
require("nvim-tree").setup({
  update_focused_file = { enable = true },
  renderer = { group_empty = true, indent_markers = { enable = true } },
  filters = { dotfiles = true },
})

map('n', '<leader>e', function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle file tree" })

-- Telescope
local builtin = require("telescope.builtin")
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>fg', builtin.git_files)
map('n', '<leader>fs', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- UndoTree
vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_SplitWidth = 60
map("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Statusline
require("lualine").setup({ options = { theme = {
  normal   = { c = { bg = 'none' } },
  inactive = { c = { bg = 'none' } },
}}
})

-- Colors
require("colorizer").setup()

-- Disable background colors for opacity
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "none" })

-- LSP
vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  on_attach = function(client, bufnr)
    local keymap_opts = { buffer = bufnr }
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr })
      vim.keymap.set("n", "<leader>ch", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr }), { bufnr })
        end)
      end
      -- Formatting with formatter.nvim as fallback
      if client.server_capabilities.documentFormattingProvider or client.server_capabilities.documentRangeFormattingProvider then
        vim.keymap.set({ "n", "v" }, "<leader>cf", vim.lsp.buf.format, keymap_opts)
      else
        vim.keymap.set({ "n", "v" }, "<leader>cf", vim.cmd.Format, keymap_opts)
      end

      vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)
      vim.keymap.set("n", "<c-h>", vim.lsp.buf.signature_help, keymap_opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, keymap_opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
      vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
      vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, keymap_opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, keymap_opts)
      vim.keymap.set("n", "<leader>in", vim.diagnostic.goto_next, keymap_opts)
      vim.keymap.set("n", "<leader>iN", vim.diagnostic.goto_prev, keymap_opts)
      vim.keymap.set("n", "<leader>io", vim.diagnostic.open_float, keymap_opts)
    end
    ,
    settings = {
      ['rust-analyzer'] = {},
    },
  })
