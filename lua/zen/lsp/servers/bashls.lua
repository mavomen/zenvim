local M = {}

M.config = {
	cmd = { "bash-language-server", "start" },
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.bash|.zsh)",
		},
	},
}

return M