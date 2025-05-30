-- for node fs.watch
vim.opt.backupcopy = 'yes'

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- List
vim.opt.list = true
vim.opt.listchars = {
	space = '·',
	tab = '  ',
	-- eol = '↴',
}

-- ETC
vim.opt.title = true
vim.opt.guicursor = ''

vim.opt.autoread = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.wrap = true
-- Searches wrap around the end of the file.
vim.opt.wrapscan = false

vim.opt.signcolumn = 'yes'
-- vim.opt.isfname:append('@-@')

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.mouse = 'a'
vim.opt.scrolloff = 16

-- column line
vim.opt.colorcolumn = "80"
vim.cmd('highlight ColorColumn guibg=#0c0f14')

-- nvim default
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showcmd = true
vim.opt.autoindent = true
vim.opt.cmdheight = 1

-- Remember last cursor
vim.api.nvim_exec2([[
	" In text files, always limit the width of text to 80 characters
	autocmd BufRead *.txt set tw=80
	" When editing a file, always jump to the last cursor position
	autocmd BufReadPost *
	\ if line("'\"") > 0 && line ("'\"") <= line("$") |
	\   exe "normal g'\"" |
	\ endif
]], { output = false })
