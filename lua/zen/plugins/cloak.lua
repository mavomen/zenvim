return {
	"laytan/cloak.nvim",
	event = "VeryLazy",
	config = function()
		require("cloak").setup({
			enabled = true,
			cloak_character = "*",
			highlight_group = "Comment",
			cloak_telescope = true,
			try_all_patterns = true,
			patterns = {
				{
					file_pattern = {
						".env*",
						"wrangler.toml",
						".dev.vars",
						"secrets.yml",
						"secrets.yaml",
						"secrets.json",
					},
					cloak_pattern = "=.+",
				},
			},
		})
	end,
}
