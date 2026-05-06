local M = {}

M.config = {
	cmd = { "sqls" },

	filetypes = { "sql", "mysql", "plsql" },

	root_markers = { ".git" },

	settings = {
		sqls = {
			connections = {},
		},
	},
}

return M
