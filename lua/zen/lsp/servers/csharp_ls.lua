local M = {}

function M.setup(capabilities)
	vim.lsp.config("csharp_ls", {
		cmd = { "csharp-ls" },
		filetypes = { "cs" },
		capabilities = capabilities,

		settings = {},
	})

	vim.lsp.handlers["textDocument/definition"] = require("csharpls_extended").handler
	vim.lsp.handlers["textDocument/typeDefinition"] = require("csharpls_extended").handler

	vim.lsp.handlers["workspace/symbol"] = function(_, result, ctx, config)
		local ok, _ = pcall(require, "telescope.builtin")
		if ok then
			vim.lsp.handlers["workspace/symbol"](nil, result, ctx, config)
			require("telescope.builtin").lsp_workspace_symbols()
		else
			vim.lsp.handlers["workspace/symbol"](nil, result, ctx, config)
		end
	end

	vim.lsp.handlers["textDocument/documentSymbol"] = function(_, result, ctx, config)
		local ok, _ = pcall(require, "telescope.builtin")
		if ok then
			vim.lsp.handlers["textDocument/documentSymbol"](nil, result, ctx, config)
			require("telescope.builtin").lsp_document_symbols()
		else
			vim.lsp.handlers["textDocument/documentSymbol"](nil, result, ctx, config)
		end
	end

	vim.lsp.handlers["textDocument/references"] = function(_, result, ctx, config)
		if not result or vim.tbl_isempty(result) then
			vim.notify("No references found")
			return
		end
		local items = vim.lsp.util.locations_to_items(result, "utf-8")
		vim.fn.setqflist({}, " ", { title = "LSP References", items = items })
		vim.api.nvim_command("copen")
	end

	vim.lsp.enable("csharp_ls")
end

return M
