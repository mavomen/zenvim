return {
	"echasnovski/mini.bufremove",
	event = "BufReadPost",
	version = false,
	config = function()
		local bufremove = require("mini.bufremove")
		bufremove.setup()

		local map = vim.keymap.set
		map("n", "<leader>bd", bufremove.delete, { desc = "Delete buffer" })
		map("n", "<leader>bD", function()
			bufremove.delete(0, true)
		end, { desc = "Force delete buffer" })
	end,
}
