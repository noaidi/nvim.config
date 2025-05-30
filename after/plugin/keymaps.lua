-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Restart LSP
vim.keymap.set(
	'n', '<leader>R',
	':LspRestart<Cr>',
	{ desc = '[R]estart LSP' }
)

-- Remap for dealing with word wrap
vim.keymap.set(
	'n', 'k',
	"v:count == 0 ? 'gk' : 'k'",
	{ expr = true, silent = true }
)
vim.keymap.set(
	'n', 'j',
	"v:count == 0 ? 'gj' : 'j'",
	{ expr = true, silent = true }
)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup(
	'YankHighlight',
	{ clear = true }
)
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- git status
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[G]it [s]tatus' })

-- centered cursor when search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- do not use vim.opt.clipboard = 'unnamedplus'
vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+Y')
vim.keymap.set('n', '<leader>x', '"+x')
vim.keymap.set('v', '<leader>x', '"+x')
vim.keymap.set('n', '<leader>X', '"+X')
