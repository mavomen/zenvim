return {
	{
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
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			modes = {
				char = { enabled = false },
			},
		},
	},

	{
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
	},

	{
		"stevearc/oil.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
		},

		config = function()
			local oil = require("oil")

			---@diagnostic disable-next-line: redundant-parameter
			oil.setup({
				default_file_explorer = true,
				show_hidden = true,

				columns = {
					"icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},

				sort = {
					{ "type", "asc" },
					{ "name", "asc" },
				},

				buf_options = {
					buflisted = false,
					bufhidden = "hide",
				},

				win_options = {
					wrap = false,
					signcolumn = "yes",
					cursorline = true,
					foldcolumn = "0",
					spell = false,
					list = false,
					conceallevel = 0,
					concealcursor = "",
					winblend = vim.fn.has("nvim-0.10") == 1 and 10 or nil,
				},

				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				prompt_save_on_select_new_entry = true,
				cleanup_delay_ms = 2000,

				lsp_file_methods = {
					timeout_ms = 1000,
					autosave_changes = false,
				},

				constrain_cursor = "editable",
				watch_for_changes = vim.fn.has("nvim-0.10") == 1,

				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-s>"] = { "actions.select", opts = { vertical = true } },
					["<C-x>"] = { "actions.select", opts = { horizontal = true } },
					["<C-t>"] = { "actions.select", opts = { tab = true } },
					["<C-p>"] = "actions.preview",
					["<C-c>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = { "actions.cd", opts = { scope = "tab" } },
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
					["gh"] = "actions.toggle_hidden",
					["q"] = "actions.close",
					["gp"] = function()
						oil.open(vim.fn.expand("%:p:h"))
					end,
				},

				use_default_keymaps = true,

				view_options = {
					show_hidden = true,
					is_hidden_file = function(name, _)
						return name:sub(1, 1) == "."
					end,
					is_always_hidden = function()
						return false
					end,
					natural_order = false,
					sort = {
						{ "type", "asc" },
						{ "name", "asc" },
					},
				},

				float = {
					padding = 2,
					border = "rounded",
					preview_split = "auto",
					win_options = vim.fn.has("nvim-0.10") == 1 and { winblend = 10 } or {},
					override = function(conf)
						return conf
					end,
				},

				preview = {
					border = "rounded",
					win_options = vim.fn.has("nvim-0.10") == 1 and { winblend = 10 } or {},
				},

				progress = {
					border = "rounded",
					win_options = vim.fn.has("nvim-0.10") == 1 and { winblend = 10 } or {},
				},

				ssh = {
					border = "rounded",
				},
			})

			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local arg = vim.fn.argv(0)
					---@diagnostic disable-next-line: param-type-mismatch
					if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
						oil.open()
					end
				end,
			})
		end,
	},
}
