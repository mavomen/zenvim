return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	keys = {
		{ "<leader>ha", desc = "Harpoon add" },
		{ "<leader>hh", desc = "Harpoon menu" },
		{ "<leader>hl", desc = "Harpoon telescope" },
		{ "<leader>1", desc = "Harpoon file 1" },
		{ "<leader>2", desc = "Harpoon file 2" },
		{ "<leader>3", desc = "Harpoon file 3" },
		{ "<leader>4", desc = "Harpoon file 4" },
		{ "<leader>5", desc = "Harpoon file 5" },
		{ "<leader>6", desc = "Harpoon file 6" },
		{ "<leader>7", desc = "Harpoon file 7" },
		{ "<leader>8", desc = "Harpoon file 8" },
		{ "<leader>9", desc = "Harpoon file 9" },
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		pcall(function()
			require("telescope").load_extension("harpoon")
		end)

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "Harpoon add" })

		vim.keymap.set("n", "<leader>hh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon menu" })

		vim.keymap.set("n", "<leader>hl", function()
			require("telescope").extensions.harpoon.marks()
		end, { desc = "Harpoon telescope" })

		for i = 1, 9 do
			vim.keymap.set("n", "<leader>" .. i, function()
				harpoon:list():select(i)
			end, { desc = "Harpoon file " .. i })
		end
	end,
}
