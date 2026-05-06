local M = {}

M.config = {
	on_attach = function(client)
		-- disable formatting (use stylua or external formatter)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,

	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},

			diagnostics = {
				globals = { "vim" },
			},

			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
					unpack(vim.api.nvim_get_runtime_file("", true)),
				},
				checkThirdParty = false,
			},

			telemetry = {
				enable = false,
			},

			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = "All",
			},
		},
	},
}

-- optional buffer extensions
function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- toggle inlay hints
	vim.keymap.set("n", "<leader>le", function()
		local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
		vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
	end, vim.tbl_extend("force", opts, { desc = "Toggle Lua inlay hints" }))

	-- reload workspace settings
	vim.keymap.set("n", "<leader>lw", function()
		client:notify("workspace/didChangeConfiguration", {
			settings = client.config.settings,
		})
		vim.notify("lua_ls workspace reloaded", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Reload lua_ls workspace" }))
end

return M
