return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},

			sections = {
				lualine_a = { "branch" },
				lualine_b = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = "󰯈 ",
							warn = " ",
							info = " ",
							hint = " ",
						},
						always_visible = true,
					},
				},
				lualine_c = {},
				lualine_x = {
					{
						-- "filetype",
						-- icon_only = true,
						-- icon = false,
						-- colored = false,
						function()
							return vim.bo.filetype
						end,
					},
				},
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = { "progress" },
			},

			tabline = {
				lualine_a = { "tabs" },
				lualine_b = { "filename" },
				lualine_c = {},
				lualine_x = {},
				lualine_y = { "diff" },
				lualine_z = {
					{
						function()
							local mode = vim.api.nvim_get_mode().mode
							local map = {
								n = "N",
								no = "N",
								i = "i",
								ic = "I",
								v = "v",
								V = "V",
								R = "R",
								c = "C",
								t = "T",
								s = "S",
							}
							return map[mode] or "?"
						end,
						padding = { left = 1, right = 1 },
					},
				},
			},

			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			inactive_winbar = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
