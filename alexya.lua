-- The custom settins from alexya

local keymap = vim.keymap -- for conciseness

keymap.set("n", "<C-p>", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
