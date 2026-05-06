local M = {}

M.config = {
	cmd = { "flux-lsp" },

	filetypes = { "flux" },

	settings = {
		flux = {
			features = {
				linting = true,
				completion = true,
				format = true,
				snippets = true,
			},
		},
	},

	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
	end,
}

return M
