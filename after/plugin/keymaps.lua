-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Delete all buffers except current
vim.keymap.set('n', '<leader>bd', function()
	local visible_bufs = {}
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		visible_bufs[buf] = true
	end

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if not visible_bufs[bufnr]
			and vim.api.nvim_buf_is_loaded(bufnr)
			and vim.bo[bufnr].buflisted
		then
			vim.api.nvim_buf_delete(bufnr, {})
		end
	end
end, { desc = "Delete all non-visible buffers" })

-- Restart LSP
-- vim.keymap.set(
-- 	'n', '<leader>R',
-- 	function()
-- 		for _, client in pairs(vim.lsp.get_clients()) do
-- 			---@diagnostic disable-next-line: param-type-mismatch
-- 			client.stop(true)
-- 		end
-- 		vim.defer_fn(function()
-- 			vim.cmd('edit')
-- 		end, 500)
-- 	end,
-- 	{ desc = '[R]estart LSP' }
-- )


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
