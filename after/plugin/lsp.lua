local lsp = require('lsp-zero')

lsp.set_sign_icons({
	error = '✘',
	warn = '▲',
	hint = '⚑',
	info = '»'
})

-- Configure each language server for neovim
local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

-- https://github.com/typescript-language-server/typescript-language-server
lspconfig.ts_ls.setup({
	settings = {
		typescript = {
			format = {
				insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
			},
		},
	},
})

lspconfig.svelte.setup({
	-- settings = {
	-- 	svelte = {
	-- 		plugin = {
	-- 			svelte = {
	-- 				compilerWarnings = {
	-- 					['a11y-no-static-element-interactions'] = 'ignore',
	-- 					['a11y-no-noninteractive-element-interactions'] = 'ignore',
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- },
})

lspconfig.eslint.setup({
	on_attach = function(_, bufnr)
		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = bufnr,
			command = 'EslintFixAll',
		})
	end,
})

lspconfig.stylelint_lsp.setup({
	filetypes = {
		'css',
		'scss',
	},
	settings = {
		stylelintplus = {
			autoFixOnFormat = true,
			autoFixOnSave = true,
		},
	},
})

lspconfig.gopls.setup({
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = false,
			},
			staticcheck = true,
		},
	},
})

-- go imports
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = { '*.go' },
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local clients = vim.lsp.get_clients({ bufnr = bufnr })

		for _, client in pairs(clients) do
			local encoding = client.offset_encoding or 'utf-16'

			local params = vim.lsp.util.make_range_params(nil, encoding)
			local code_action_params = {
				textDocument = params.textDocument,
				range = params.range,
				context = { only = { 'source.organizeImports' } }
			}

			local result = vim.lsp.buf_request_sync(
				bufnr,
				'textDocument/codeAction',
				code_action_params,
				3000
			)

			if not result then return end

			for _, res in pairs(result) do
				for _, action in pairs(res.result or {}) do
					if action.edit then
						vim.lsp.util.apply_workspace_edit(action.edit, encoding)
					elseif type(action.command) == 'table' then
						vim.lsp.buf.execute_client_command(action.command)
					end
				end
			end
		end
	end,
})
-- vim.api.nvim_create_autocmd('BufWritePre', {
-- 	pattern = { '*.go' },
-- 	callback = function()
-- 		local clients = vim.lsp.get_clients()
-- 		for _, client in pairs(clients) do
-- 			local params = vim.lsp.util.make_range_params(
-- 				nil,
-- 				client.offset_encoding
-- 			)
-- 			params.context = { only = { 'source.organizeImports' } }
-- 			local result = vim.lsp.buf_request_sync(
-- 				0,
-- 				'textDocument/codeAction',
-- 				params,
-- 				5000
-- 			)
-- 			for _, res in pairs(result or {}) do
-- 				for _, r in pairs(res.result or {}) do
-- 					if r.edit then
-- 						vim.lsp.util.apply_workspace_edit(
-- 							r.edit, client.offset_encoding
-- 						)
-- 					else
-- 						vim.lsp.buf.execute_command(r.command)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end,
-- })

-- vim.api.nvim_create_autocmd('BufWritePost', {
-- 	pattern = { '*.ts', '*.svelte' },
-- 	callback = function()
-- 		vim.cmd('LspRestart')
-- 	end,
-- })

local builtin = require('telescope.builtin')
lsp.on_attach(function(client, bufnr)
	-- Format on save
	if client.name == "ts_ls" then
		client.server_capabilities.documentFormattingProvider = false
	end
	require('lsp-format').on_attach(client)

	-- Keymaps
	lsp.default_keymaps({ buffer = bufnr })

	local nmap = function(keys, func, desc)
		if desc then
			desc = 'LSP: ' .. desc
		end

		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap(
		'<leader>rn',
		vim.lsp.buf.rename,
		'[R]e[n]ame'
	)
	nmap(
		'<leader>ca',
		vim.lsp.buf.code_action,
		'[C]ode [A]ction'
	)

	nmap(
		'gd',
		vim.lsp.buf.definition,
		'[G]oto [D]efinition'
	)
	nmap(
		'gr',
		builtin.lsp_references,
		'[G]oto [R]eferences'
	)
	nmap(
		'gI',
		vim.lsp.buf.implementation,
		'[G]oto [I]mplementation'
	)
	nmap(
		'<leader>D',
		vim.lsp.buf.type_definition,
		'Type [D]efinition'
	)
	nmap(
		'<leader>ds',
		builtin.lsp_document_symbols,
		'[D]ocument [S]ymbols'
	)
	nmap(
		'<leader>ws',
		builtin.lsp_dynamic_workspace_symbols,
		'[W]orkspace [S]ymbols'
	)

	-- See `:help K` for why this keymap
	nmap(
		'K',
		vim.lsp.buf.hover,
		'Hover Documentation'
	)
	nmap(
		'<C-k>',
		vim.lsp.buf.signature_help,
		'Signature Documentation'
	)

	-- Lesser used LSP functionality
	nmap(
		'gD',
		vim.lsp.buf.declaration,
		'[G]oto [D]eclaration'
	)
	nmap(
		'<leader>wa',
		vim.lsp.buf.add_workspace_folder,
		'[W]orkspace [A]dd Folder'
	)
	nmap(
		'<leader>wr',
		vim.lsp.buf.remove_workspace_folder,
		'[W]orkspace [R]emove Folder'
	)
	nmap(
		'<leader>wl',
		function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end,
		'[W]orkspace [L]ist Folders'
	)
end)

lsp.setup()

-- cmp
local cmp = require('cmp')
-- local cmp_action = lsp.cmp_action()
cmp.setup({
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'buffer',  keyword_length = 3 },
		{ name = 'luasnip', keyword_length = 2 },
	},
	mapping = {
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		-- Ctrl+Enter to trigger completion menu
		['<C-CR>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		-- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
		-- ['<C-b>'] = cmp_action.luasnip_jump_backward(),

		-- Tab key to select next completion item or insert tab character
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { 'i', 's' }),

		-- Shift+Tab key to select previous completion item
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
	}
})

-- :MasonInstall gopls
-- :MasonInstall svelte-language-server
-- :MasonInstall typescript-language-server
-- :MasonInstall eslint-lsp
-- :MasonInstall prettier
-- :MasonInstall stylelint
-- :MasonInstall stylelint-lsp
-- :MasonInstall glsl_analyzer
require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = {
		-- lua
		'lua_ls',

		-- Svelte
		'svelte',
		'ts_ls',
		'eslint',

		-- SCSS
		'stylelint_lsp',

		-- Go
		'gopls',

		-- GLSL
		'glsl_analyzer',
	},
})
