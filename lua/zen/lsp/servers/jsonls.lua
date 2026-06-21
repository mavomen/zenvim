local M = {}

M.config = {
	cmd = { "vscode-json-languageserver", "--stdio" },
	settings = {
		json = {
			validate = { enable = true },
		},
	},
}

return M