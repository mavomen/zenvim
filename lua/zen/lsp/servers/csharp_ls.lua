local M = {}

M.config = {
	cmd = { "csharp-ls" },
	filetypes = { "cs" },
	root_markers = { ".git", ".sln", ".csproj" },
	single_file_support = true,
}

return M
