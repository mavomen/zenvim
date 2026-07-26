return {
	"foolofafitz/mql.nvim",
	ft = { "mql5", "mq5", "mqh" },
	keys = {
		{
			"<leader>md",
			function()
				local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
				local script = git_root .. "/scripts/deploy.sh"
				if vim.fn.filereadable(script) == 0 then
					vim.notify("deploy.sh not found at " .. script, vim.log.levels.WARN)
					return
				end
				vim.fn.system(script)
				local exit_code = vim.v.shell_error
				if exit_code == 0 then
					vim.notify("deployed to MT5", vim.log.levels.INFO)
				else
					vim.notify("deploy failed (exit " .. exit_code .. ")", vim.log.levels.ERROR)
				end
			end,
			desc = "MQL5: Deploy .ex5 to MT5",
		},
	},
	opts = {
		metaeditor_path = vim.fn.expand("~/.wine/drive_c/Program Files/MetaTrader 5/metaeditor64.exe"),
		mql5_include_path = vim.fn.expand("~/.wine/drive_c/Program Files/MetaTrader 5/MQL5"),
		bind_key = "<F7>",
	},
}
