local M = {}

M.config = {
	cmd = { "sql-language-server", "up", "--method", "stdio" },

	filetypes = { "sql", "tsql" },

	root_markers = { ".git" },

	settings = {
		sql = {
			connections = {},
			linting = {
				enabled = true,
			},
			formatting = {
				enabled = true,
			},
		},
	},
}

return M
