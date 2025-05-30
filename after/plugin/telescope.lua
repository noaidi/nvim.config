-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope = require('telescope')
telescope.setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, 'fzf')

-- See `:help telescope.builtin`
local builtin = require('telescope.builtin')

vim.keymap.set(
	'n', '<leader>O',
	builtin.oldfiles,
	{ desc = 'List recently opened [O]ld files' }
)

vim.keymap.set(
	'n', '<C-L>',
	builtin.buffers,
	{ desc = '[L]ist existing buffers' }
)

vim.keymap.set(
	'n', '<leader><space>',
	builtin.find_files,
	{ desc = 'Find [F]files' }
)

-- vim.keymap.set(
-- 	'n', '<leader><space>',
-- 	builtin.git_files,
-- 	{ desc = 'Git files' }
-- )

-- vim.keymap.set(
-- 	'n', '<leader>/',
-- 	function()
-- 		-- You can pass additional configuration to telescope
-- 		-- to change theme, layout, etc.
-- 		builtin.current_buffer_fuzzy_find(
-- 			require('telescope.themes').get_dropdown {
-- 				winblend = 10,
-- 				previewer = false,
-- 			}
-- 		)
-- 	end,
-- 	{ desc = '[/] Fuzzily search in current buffer' }
-- )

-- require: brew install ripgrep
vim.keymap.set(
	'n', '<leader>G',
	builtin.live_grep,
	{ desc = '[G]rep' }
)

vim.keymap.set(
	'n', '<leader>W',
	builtin.grep_string,
	{ desc = 'Grep [W]ord' }
)

vim.keymap.set(
	'n', '<leader>H',
	builtin.help_tags,
	{ desc = 'Search [H]elp' }
)

local actions = require('telescope.actions')
local transform_mod = require("telescope.actions.mt").transform_mod
local action_state = require('telescope.actions.state')

local function multiopen(prompt_bufnr, method)
	local edit_file_cmd_map = {
		vertical = "vsplit",
		horizontal = "split",
		tab = "tabedit",
		default = "edit",
	}
	local edit_buf_cmd_map = {
		vertical = "vert sbuffer",
		horizontal = "sbuffer",
		tab = "tab sbuffer",
		default = "buffer",
	}
	local picker = action_state.get_current_picker(prompt_bufnr)
	local multi_selection = picker:get_multi_selection()

	if #multi_selection <= 1 then
		actions["select_default"](prompt_bufnr)
		return
	end

	require("telescope.pickers").on_close_prompt(prompt_bufnr)
	pcall(vim.api.nvim_set_current_win, picker.original_win_id)

	for i, entry in ipairs(multi_selection) do
		local filename, row, col

		if entry.path or entry.filename then
			filename = entry.path or entry.filename
			row = entry.row or entry.lnum
			col = vim.F.if_nil(entry.col, 1)
		elseif not entry.bufnr then
			local value = entry.value
			if not value then
				return
			end

			if type(value) == "table" then
				value = entry.display
			end

			local sections = vim.split(value, ":")
			filename = sections[1]
			row = tonumber(sections[2])
			col = tonumber(sections[3])
		end

		local entry_bufnr = entry.bufnr

		if entry_bufnr then
			if not vim.api.nvim_buf_get_option(entry_bufnr, "buflisted") then
				vim.api.nvim_buf_set_option(entry_bufnr, "buflisted", true)
			end
			local command = i == 1 and "buffer" or edit_buf_cmd_map[method]

			pcall(vim.cmd, string.format(
				"%s %s", command, vim.api.nvim_buf_get_name(entry_bufnr)
			))
		else
			local command = i == 1 and "edit" or edit_file_cmd_map[method]
			if
				vim.api.nvim_buf_get_name(0) ~= filename or
				command ~= "edit"
			then
				filename = require("plenary.path")
					:new(vim.fn.fnameescape(filename))
					:normalize(vim.loop.cwd())
				pcall(vim.cmd, string.format("%s %s", command, filename))
			end
		end

		if row and col then
			pcall(vim.api.nvim_win_set_cursor, 0, { row, col - 1 })
		end
	end
end

local custom_actions = transform_mod({
	multi_selection_open_vertical = function(prompt_bufnr)
		multiopen(prompt_bufnr, "vertical")
	end,
	multi_selection_open_horizontal = function(prompt_bufnr)
		multiopen(prompt_bufnr, "horizontal")
	end,
	-- multi_selection_open_tab = function(prompt_bufnr)
	-- 	multiopen(prompt_bufnr, "tab")
	-- end,
	-- multi_selection_open = function(prompt_bufnr)
	-- 	multiopen(prompt_bufnr, "default")
	-- end,
})

local mappings = {
	["<ESC>"] = actions.close,
	["<C-J>"] = actions.move_selection_next,
	["<C-K>"] = actions.move_selection_previous,
	["<TAB>"] = actions.toggle_selection,
	["<CR>"] = custom_actions.multi_selection_open_horizontal,
	["<C-V>"] = custom_actions.multi_selection_open_vertical,
}
require('telescope').setup({
	defaults = {
		mappings = {
			i = mappings,
			n = mappings,
		},
	}
})
