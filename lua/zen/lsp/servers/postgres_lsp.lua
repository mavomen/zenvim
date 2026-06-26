local M = {}

M.config = {
	cmd = { "postgres_lsp" },

	filetypes = { "sql", "pgsql", "plpgsql" },

	root_markers = { ".git" },

	settings = {
		postgres = {
			connection = {
				host = "localhost",
				port = 5432,
			},

			plpgsql = {
				enabled = true,
				linting = true,
			},
		},
	},
}

return M
