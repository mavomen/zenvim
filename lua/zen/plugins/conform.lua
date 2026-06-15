return {
	"stevearc/conform.nvim",
	lazy = true,
	cmd = { "ConformInfo" },
	priority = 10,

	keys = {
		{
			"<leader>lff",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
		{
			"<leader>;f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black", "isort" },
			csharp = { "csharpier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			go = { "gofmt", "goimports" },
			rust = { "rustfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			sh = { "shfmt" },
		},

		formatters = {
			black = {
				command = "/usr/bin/black",
			},
			isort = {
				command = "/usr/bin/isort",
			},
			prettier = {
				command = "prettier",
			},
			rustfmt = {
				command = "rustfmt",
				stdin = true,
			},
		},

		format_on_save = function(bufnr)
			if vim.api.nvim_buf_line_count(bufnr) > 5000 then
				return
			end

			return {
				timeout_ms = 500,
				lsp_fallback = true,
			}
		end,
	},
}
