-- Claude Code integration (coder/claudecode.nvim)
require("claudecode").setup({
  focus_after_send = true, -- auto-focus the terminal after :ClaudeCodeSend
})

local map = vim.keymap.set

map("n", "<leader>ac", "<cmd>ClaudeCode<cr>",            { desc = "Toggle Claude" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       { desc = "Focus Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   { desc = "Resume Claude session" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude session" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Pick Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       { desc = "Add current buffer to Claude" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>",        { desc = "Send selection to Claude" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",  { desc = "Accept Claude diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",    { desc = "Deny Claude diff" })

-- Window navigation from inside the Claude terminal (one-step, no <C-\><C-n> prelude).
for _, dir in ipairs({ "h", "j", "k", "l" }) do
  map("t", "<C-w>" .. dir, [[<C-\><C-n><C-w>]] .. dir, { desc = "Move to " .. dir .. " window" })
end

-- Inside the Claude terminal, <Esc> drops straight to normal mode.
-- (Trade-off: Claude's TUI loses its own Esc — use <C-c> to cancel input instead.)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*claude*",
  callback = function(args)
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf, desc = "Exit terminal mode" })
  end,
})
