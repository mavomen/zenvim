local M = {}

M.config = {
	cmd = { "gopls" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			gofumpt = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
}

return M