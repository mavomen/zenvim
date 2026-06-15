-- lua/zen/lsp/servers/csharp_ls.lua
local M = {}

M.config = {
	cmd = { "csharp-ls" },
	filetypes = { "cs" },
	root_markers = { ".git", ".sln", ".csproj" },
	single_file_support = true,

	-- Custom LSP handlers to improve the development experience
	handlers = {
		-- 1. Decompiled source for "Go to Definition" (from the plugin)
		["textDocument/definition"] = require("csharpls_extended").handler,
		["textDocument/typeDefinition"] = require("csharpls_extended").handler,

		-- 2. Fancy hover window with a border and fixed width
		["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", max_width = 80 }),

		-- 3. Signature help with highlighted active parameter and a border
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "rounded",
			focusable = false,
			-- Disable dynamic registration so it always uses our style
			silent = true,
		}),

		-- 4. Workspace symbols using Telescope (if you use it) - much better than the default
		["workspace/symbol"] = function(_, result, ctx, config)
			-- Fall back to built-in if Telescope isn't installed
			local ok, _ = pcall(require, "telescope.builtin")
			if ok then
				vim.lsp.handlers["workspace/symbol"](nil, result, ctx, config) -- still register results
				require("telescope.builtin").lsp_workspace_symbols()
			else
				vim.lsp.handlers["workspace/symbol"](nil, result, ctx, config)
			end
		end,

		-- 5. Document symbols using Telescope (optional)
		["textDocument/documentSymbol"] = function(_, result, ctx, config)
			local ok, _ = pcall(require, "telescope.builtin")
			if ok then
				vim.lsp.handlers["textDocument/documentSymbol"](nil, result, ctx, config)
				require("telescope.builtin").lsp_document_symbols()
			else
				vim.lsp.handlers["textDocument/documentSymbol"](nil, result, ctx, config)
			end
		end,

		-- 6. Show references in a quickfix list for easy navigation
		["textDocument/references"] = function(_, result, ctx, config)
			if not result or vim.tbl_isempty(result) then
				vim.notify("No references found")
				return
			end
			local items = vim.lsp.util.locations_to_items(result, "utf-8")
			vim.fn.setqflist({}, " ", { title = "LSP References", items = items })
			vim.api.nvim_command("copen")
		end,
	},
}

return M
