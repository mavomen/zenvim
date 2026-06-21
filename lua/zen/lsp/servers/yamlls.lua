local M = {}

M.config = {
	cmd = { "yaml-language-server", "--stdio" },
	settings = {
		yaml = {
			validate = true,
			hover = true,
			completion = true,
			format = {
				enable = true,
				singleQuote = false,
			},
		},
	},
}

return M