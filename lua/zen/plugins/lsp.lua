return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local function on_attach(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
				end

				map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "K", vim.lsp.buf.hover, "Hover")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
				map("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, "Format")
			end

			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_dir = function(fname)
					return vim.fs.root(fname, {
						".luarc.json",
						".luarc.jsonc",
						".git",
					}) or vim.loop.cwd()
				end,
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_dir = function(fname)
					return vim.fs.root(fname, {
						"pyproject.toml",
						"setup.py",
						".git",
					}) or vim.loop.cwd()
				end,
				capabilities = capabilities,
				on_attach = on_attach,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "lua",
				callback = function(ev)
					vim.lsp.start("lua_ls", { bufnr = ev.buf })
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function(ev)
					vim.lsp.start("pyright", { bufnr = ev.buf })
				end,
			})
		end,
	},

	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright" },
				automatic_installation = true,
			})
		end,
	},
	{
		"Decodetalkers/csharpls-extended-lsp.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function() end,
	},
}
