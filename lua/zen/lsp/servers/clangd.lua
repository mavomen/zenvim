local M = {}

M.config = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "cuda" },
	root_markers = { ".clangd", ".git" },
}

return M
