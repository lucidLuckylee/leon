-- The main colorscheme file
-- To use this, save it in ~/.config/nvim/lua/rich_reds.lua
-- Then run :colorscheme rich_reds in Neovim

local M = {}

-- 1. Define the custom color palette based on user input
local colors = {
  fg = "#ffd5d5", -- Rose/Light Pink for foreground (Rose)
  bg = "#000000", -- Pure Black background
  cursor_fg = "#000000",
  cursor_bg = "#ffd5d5",

  -- User-defined ANSI colors
  dark_grey = "#2A2A2A",
  
  -- Updated Grey for Line Numbers (darker for subtlety)
  medium_grey = "#5A5A5A", 

  light_white = "#EEDFC7",
  
  -- Primary syntax colors (Darker Reds and Orange-Brownish Amber)
  red = "#7D0000",           -- New Deep Red (used for comments, statements, delete signs)
  bright_red = "#B00000",    -- New Bright Red (used for keywords, operators)
  amber = "#CC8800",         -- New Orange-Brownish Amber (used for strings, numbers)
  bright_amber = "#FF9900",  -- New Bright Amber (used for constants, search)
  purple = "#6B006B",        -- New Darker Purple/Magenta (used for functions, types)
  bright_purple = "#AD008D", -- Bright Dark Purple/Magenta
  
  -- Secondary/Utility colors (unused 'green' removed from palette, but keeping structure clean)
}

-- Helper function to set highlight groups
local function highlight(group, settings)
  vim.api.nvim_set_hl(0, group, settings)
end

-- 2. Define the highlight groups
function M.colorscheme()
  -- Clear all existing highlights
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "rich_red"

  -- --- Base Groups ---
  highlight("Normal", { fg = colors.fg, bg = colors.bg })
  highlight("Terminal", { fg = colors.fg, bg = colors.bg })
  highlight("Visual", { bg = colors.dark_grey }) -- Subtle selection
  highlight("Search", { fg = colors.bg, bg = colors.bright_amber }) -- High contrast search result
  highlight("IncSearch", { fg = colors.bg, bg = colors.bright_red }) -- Current search match

  -- --- Status and Diagnostic Groups ---
  highlight("LineNr", { fg = colors.medium_grey, bg = colors.bg }) -- Darker grey for subtlety
  highlight("CursorLineNr", { fg = colors.bright_red, bg = colors.bg, bold = true })
  highlight("CursorLine", { bg = colors.dark_grey })
  highlight("NonText", { fg = colors.medium_grey }) -- Also making non-text darker
  highlight("Folded", { fg = colors.purple, bg = colors.dark_grey })
  highlight("SignColumn", { bg = colors.bg })
  highlight("PMenu", { fg = colors.fg, bg = colors.dark_grey }) -- Pop-up menu background
  highlight("PMenuSel", { fg = colors.bg, bg = colors.purple }) -- Pop-up menu selection

  -- Diagnostics (Error/Warning/Info/Hint)
  highlight("DiagnosticError", { fg = colors.bright_red })
  highlight("DiagnosticWarning", { fg = colors.bright_amber })
  highlight("DiagnosticInfo", { fg = colors.purple })
  highlight("DiagnosticHint", { fg = colors.medium_grey })

  -- --- Syntax Highlighting ---

  -- 1. Keywords, Statements, and Operators (Red/Purple priority)
  highlight("Keyword", { fg = colors.bright_red })         -- 'if', 'for', 'while'
  highlight("Statement", { fg = colors.red, bold = true }) -- 'return', 'break', 'new'
  highlight("Operator", { fg = colors.bright_red })        -- '+', '=', '>', '&&'
  highlight("Delimiter", { fg = colors.fg })               -- Brackets, parens
  highlight("Exception", { fg = colors.bright_red, bold = true })

  -- 2. Functions, Types, and Variables (Dark Purple/Magenta priority)
  highlight("Function", { fg = colors.purple, bold = true }) -- Function definitions and calls
  highlight("Type", { fg = colors.bright_purple })           -- Built-in types ('int', 'string')
  highlight("StorageClass", { fg = colors.purple })          -- 'var', 'let', 'const', 'public'
  highlight("Structure", { fg = colors.purple })             -- struct/class names
  highlight("Identifier", { fg = colors.fg })                -- Default variable names (Rose/Light)

  -- 3. Constants, Strings, and Numbers (Amber/Yellow priority)
  highlight("String", { fg = colors.amber })               -- Text inside quotes
  highlight("Character", { fg = colors.bright_amber })     -- Single characters
  highlight("Number", { fg = colors.amber })               -- Numeric literals
  highlight("Boolean", { fg = colors.bright_amber })       -- 'true', 'false'
  highlight("Constant", { fg = colors.bright_amber })      -- Read-only constants

  -- 4. Comments (Deep Red, acting as a soft warning/note)
  highlight("Comment", { fg = colors.red, italic = true })
  highlight("SpecialComment", { fg = colors.bright_red, bold = true })

  -- 5. Preprocessor and Includes
  highlight("PreProc", { fg = colors.purple }) -- #include, #define
  highlight("Macro", { fg = colors.bright_red })

  -- 6. Git Gutter (Strictly Red/Amber/Purple family)
  highlight("GitSignsAdd", { fg = colors.bright_red })    -- Addition (Red instead of Green)
  highlight("GitSignsChange", { fg = colors.amber })     -- Change (Amber)
  highlight("GitSignsDelete", { fg = colors.red })       -- Delete (Deep Red)

end

return M
