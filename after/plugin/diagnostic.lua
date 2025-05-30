local builtin = require('telescope.builtin')

-- Diagnostic keymaps
vim.keymap.set(
	'n', '<leader>dd',
	builtin.diagnostics,
	{ desc = '[D]iagnostics' }
)
vim.keymap.set(
	'n', '[d',
	vim.diagnostic.goto_prev,
	{ desc = "Go to previous diagnostic message" }
)
vim.keymap.set(
	'n', ']d',
	vim.diagnostic.goto_next,
	{ desc = "Go to next diagnostic message" }
)
vim.keymap.set(
	'n', '<leader>df',
	vim.diagnostic.open_float,
	{ desc = "Open floating diagnostic message" }
)
vim.keymap.set(
	'n', '<leader>dl',
	vim.diagnostic.setloclist,
	{ desc = "Open diagnostics list" }
)

