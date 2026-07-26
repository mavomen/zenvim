local M = {}

M.config = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "cuda", "mql5" },
	root_markers = { ".clangd", "compile_flags.txt", ".git" },
}

return M
