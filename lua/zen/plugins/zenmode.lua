return {
	"folke/zen-mode.nvim",
	keys = {
		{ "<leader>zz", desc = "Zen mode" },
	},
	opts = {
		window = {
			backdrop = 1.0,
			width = 100,
			options = {
				number = false,
				relativenumber = false,
				signcolumn = "no",
				foldcolumn = "0",
				cursorline = false,
				list = false,
			},
		},
		plugins = {
			options = {
				enabled = true,
				ruler = false,
				showcmd = false,
				laststatus = 0,
			},
			gitsigns = { enabled = false },
			kitty = { enabled = true, font = "+4" },
			alacritty = { enabled = true, font = "14" },
		},
		on_open = function(_) end,
		on_close = function() end,
	},
	config = function(_, opts)
		vim.g.zen_active = false
		vim.g.zen_width = 90

		require("zen-mode").setup(opts)

		vim.keymap.set("n", "<leader>zz", function()
			vim.g.zen_active = not vim.g.zen_active
			if vim.g.zen_active then
				vim.g.zen_width = 90
			end
			require("zen-mode").toggle()
		end, { desc = "Zen mode" })
	end,
}
