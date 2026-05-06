return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",

		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},

	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({})

		-- optional: extend TS/JS JSX support
		luasnip.filetype_extend("javascript", { "javascriptreact" })
		luasnip.filetype_extend("typescript", { "typescriptreact" })

		-- minimal icons (comment out if you hate icons entirely)
		local icons = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰡱",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Property = "󰜢",
			Value = "󰎠",
			Snippet = "",
			File = "󰈙",
			Folder = "󰉋",
			Operator = "󰆕",
			Keyword = "󰌋",
		}

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),

				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer", keyword_length = 3 },
				{ name = "path" },
			}),

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, item)
					local icon = icons[item.kind]
					if icon then
						item.kind = icon .. "  " .. item.kind
					end

					item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snp]",
						buffer = "[Buf]",
						path = "[Path]",
						cmdline = "[Cmd]",
					})[entry.source.name] or ""

					return item
				end,
			},

			experimental = {
				ghost_text = false,
			},
		})

		-- Search `/` `?`
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Command-line `:`
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
				{ name = "cmdline" },
			}),
		})
	end,
}
