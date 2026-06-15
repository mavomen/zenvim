local M = {}

function M.setup(capabilities)
	vim.lsp.config("csharp_ls", {
		cmd = { "csharp-ls" },
		filetypes = { "cs" },
		capabilities = capabilities,

		settings = {},
	})

	vim.lsp.enable("csharp_ls")
end

return M