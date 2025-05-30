local f_buf
local x_buf
local win
local active

local init = function()
	f_buf = -1
	x_buf = -1
	win = -1
	active = false
end

init()

-- local function is_no_name_buf(buf)
-- 	return
-- 		vim.api.nvim_buf_is_loaded(buf)
-- 		and vim.api.nvim_buf_get_option(buf, 'buflisted')
-- 		and vim.api.nvim_buf_get_name(buf) == ''
-- 		and vim.api.nvim_buf_get_option(buf, 'buftype') == ''
-- 		and vim.api.nvim_buf_get_option(buf, 'filetype') == ''
-- end

local toggle_explore = function()
	-- local all_no_name = vim.tbl_filter(
	-- 	is_no_name_buf,
	-- 	vim.api.nvim_list_bufs()
	-- )
	-- for _, bf in pairs(all_no_name or {}) do
	-- 	vim.cmd('bwipeout ' .. bf)
	-- end

	local w = vim.api.nvim_get_current_win()
	local b = vim.api.nvim_get_current_buf()
	if active and w == win and b == x_buf then
		if f_buf > 0 and win > 0 then
			vim.api.nvim_win_set_buf(win, f_buf)
			vim.cmd('bwipeout ' .. b)
		end
		init()
		return
	end

	win = w
	f_buf = b
	vim.cmd('Explore')
	x_buf = vim.api.nvim_get_current_buf()
	active = true
end

vim.keymap.set('n', 'Q', toggle_explore, { desc = 'Toggle explore' })

vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = 'name'
