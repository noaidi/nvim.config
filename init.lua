vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.sass_recommended_style = 0

-- Install package manager
-- https://github.com/folke/lazy.nvim
-- `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
if vim.fn.filereadable(lazypath) == 0 then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- NOTE:
-- Here is where you install your plugins.
-- You can configure plugins using the `config` key.
--
-- You can also configure plugins after the setup call,
-- as they will be available in your neovim runtime.

require('lazy').setup({
	-- NOTE:
	-- First, some plugins that don't require any configuration

	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Detect tabstop and shiftwidth automatically
	--'tpope/vim-sleuth',

	-- LSP Configuration
	{
		'VonHeikemen/lsp-zero.nvim',
		dependencies = {
			'neovim/nvim-lspconfig',
			{
				'williamboman/mason.nvim',
				build = ':MasonUpdate',
			},
			'williamboman/mason-lspconfig.nvim',
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',

			-- Autocompletion
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'L3MON4D3/LuaSnip',

			'rafamadriz/friendly-snippets',

			-- Format on save
			{ 'lukas-reineke/lsp-format.nvim', config = true },
		},
	},

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim', opts = {} },
	{
		-- Adds git releated signs to the gutter,
		-- as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},

	-- Theme
	{
		'projekt0n/github-nvim-theme',
		config = function()
			require('github-theme').setup({
				experiments = {
					new_paletts = true,
				},
			})
			vim.opt.background = 'dark'
			vim.cmd.colorscheme 'github_dark_tritanopia'
		end,
	},

	-- Set lualine as statusline
	{
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = 'horizon',
				component_separators = '',
				section_separators = '',
			},
			sections = {
				lualine_c = { {
					'filename',
					path = 1,
				} },
			},
		},
	},

	-- Add indentation guides even on blank lines
	-- {
	-- 	'lukas-reineke/indent-blankline.nvim',
	-- 	config = function()
	-- 		vim.opt.list = true
	-- 		vim.opt.listchars:append 'space:·'
	-- 		require('indent_blankline').setup({
	-- 			char = '│', --┊|
	-- 			space_char_blankline = ' ',
	-- 		})
	-- 	end,
	-- },

	-- "gc" to comment visual regions/lines
	--
	-- [NORMAL mode]
	-- `gcc`				- Toggles the current line using linewise comment
	-- `gbc`				- Toggles the current line using blockwise comment
	-- `[count]gcc`			- Toggles the number of line given
	--						  as a prefix-count using linewise
	-- `[count]gbc`			- Toggles the number of line given
	--						  as a prefix-count using blockwise
	-- `gc[count]{motion}`	- (Op-pending) Toggles the region
	--						  using linewise comment
	-- `gb[count]{motion}`	- (Op-pending) Toggles the region
	--						  using blockwise comment
	--
	-- [VISUAL mode]
	-- `gc`					- Toggles the region using linewise comment
	-- `gb`					- Toggles the region using blockwise comment
	{
		'numToStr/Comment.nvim',
		opts = {
			toggler = {
				line = '<C-/>',
			},
			opleader = {
				line = '<C-/>',
			},
		},
	},

	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	-- {
	-- 	'nvim-telescope/telescope-fzf-native.nvim',
	-- 	-- NOTE:
	-- 	-- If you are having trouble with this installation,
	-- 	-- refer to the README for telescope-fzf-native for more instructions.
	-- 	build = 'make',
	-- 	cond = function()
	-- 		return vim.fn.executable 'make' == 1
	-- 	end,
	-- },

	-- Highlight, edit, and navigate code
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		build = ":TSUpdate",
	},

	-- nvim-rooter
	{
		'notjedi/nvim-rooter.lua',
		opts = {
			manual = false,
			root_patterns = { '.git', 'package.json' },
		},
	},
}, {})
