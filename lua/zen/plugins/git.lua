return {
	"lewis6991/gitsigns.nvim",

	event = { "BufReadPre", "BufNewFile" },

	opts = {

		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▁" },
			topdelete = { text = "‾" },
			changedelete = { text = "▎" },
		},

		signcolumn = true,
		numhl = false,
		linehl = false,

		word_diff = false,

		current_line_blame = false,

		watch_gitdir = {
			interval = 2000,
			follow_files = true,
		},

		attach_to_untracked = true,

		update_debounce = 200,
		max_file_length = 40000,
	},

	config = function(_, opts)
		require("gitsigns").setup(opts)
	end,
}
