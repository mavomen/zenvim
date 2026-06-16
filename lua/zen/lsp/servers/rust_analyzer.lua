local M = {}

function M.setup(capabilities)
	vim.lsp.config("rust_analyzer", {
		capabilities = capabilities,

		settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},

				cargo = {
					buildScripts = {
						enable = true,
					},
					allFeatures = true,
				},

				procMacro = {
					enable = true,
				},

				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},

				inlayHints = {
					chainingHints = {
						enable = true,
					},
					parameterHints = {
						enable = true,
					},
					typeHints = {
						enable = true,
					},
				},
			},
		},
	})

	vim.lsp.enable("rust_analyzer")
end

function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "<leader>re", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = { only = { "rust-analyzer.expandMacro" }, diagnostics = {} },
		})
	end, vim.tbl_extend("force", opts, { desc = "Expand macro (Rust)" }))

	vim.keymap.set("n", "<leader>rc", function()
		local root = client.config.root_dir or vim.fn.getcwd()
		local cargo = root .. "/Cargo.toml"
		if vim.fn.filereadable(cargo) == 1 then
			vim.cmd.edit(cargo)
		else
			vim.notify("Cargo.toml not found", vim.log.levels.WARN)
		end
	end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))

	vim.keymap.set("n", "<leader>rr", function()
		client:request("rust-analyzer/reloadWorkspace", nil, function(err)
			if err then
				vim.notify("reload failed: " .. tostring(err), vim.log.levels.ERROR)
			else
				vim.notify("rust-analyzer: workspace reloaded", vim.log.levels.INFO)
			end
		end, bufnr)
	end, vim.tbl_extend("force", opts, { desc = "Reload workspace (Rust)" }))

	vim.keymap.set("n", "<leader>rt", function()
		client:request("rust-analyzer/runSingle", {
			textDocument = vim.lsp.util.make_text_document_params(),
			position = vim.api.nvim_win_get_cursor(0),
		})
	end, vim.tbl_extend("force", opts, { desc = "Run test (Rust)" }))
end

return M
