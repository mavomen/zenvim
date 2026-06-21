local M = {}

M.config = {
	cmd = { "pyright-langserver", "--stdio" },
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
			},
		},
	},
}

return M
