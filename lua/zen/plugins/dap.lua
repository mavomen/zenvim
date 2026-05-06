return {

	{
		"mfussenegger/nvim-dap",

		cmd = {
			"DapContinue",
			"DapToggleBreakpoint",
			"DapStepOver",
			"DapStepInto",
			"DapStepOut",
		},

		dependencies = {

			-- UI
			{
				"rcarriga/nvim-dap-ui",
				dependencies = "nvim-neotest/nvim-nio",
			},

			-- Mason bridge
			{
				"jay-babu/mason-nvim-dap.nvim",
				dependencies = {
					"williamboman/mason.nvim",
					"mfussenegger/nvim-dap",
				},

				config = function()
					require("mason-nvim-dap").setup({

						automatic_installation = true,

						ensure_installed = {
							"python",
							"codelldb",
							"delve",
							"netcoredbg",
						},
					})
				end,
			},
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			dap.listeners.before.attach.dapui = function()
				dapui.open()
			end

			dap.listeners.before.launch.dapui = function()
				dapui.open()
			end

			dap.listeners.before.event_terminated.dapui = function()
				dapui.close()
			end

			dap.listeners.before.event_exited.dapui = function()
				dapui.close()
			end

			-- .NET adapter
			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			local function find_dll()
				local patterns = {
					"**/bin/Debug/net*/!(*Test*).dll",
					"**/bin/Debug/net*/*.dll",
					"bin/Debug/net*/*.dll",
					"**/Debug/*.dll",
				}

				for _, p in ipairs(patterns) do
					local matches = vim.fn.glob(p, false, true)
					if matches and #matches > 0 then
						return matches[1]
					end
				end

				return nil
			end

			local function build_project()
				print("dotnet build...")
				local result = vim.fn.system("dotnet build 2>&1")

				if vim.v.shell_error ~= 0 then
					print(result)
					return false
				end

				print("build success")
				return true
			end

			dap.configurations.cs = {

				{
					type = "coreclr",
					name = "Launch .NET",
					request = "launch",
					console = "integratedTerminal",

					program = function()
						if vim.fn.confirm("Build first?", "&yes\n&no", 2) == 1 then
							if not build_project() then
								if vim.fn.confirm("Build failed. Continue?", "&yes\n&no", 2) ~= 1 then
									return nil
								end
							end
						end

						local dll = find_dll()

						if dll then
							print("DLL: " .. dll)
							if vim.fn.confirm("Use found DLL?", "&yes\n&choose", 1) == 1 then
								return dll
							end
						end

						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},

				{
					type = "coreclr",
					name = "Launch .NET (no build)",
					request = "launch",
					console = "integratedTerminal",

					program = function()
						local dll = find_dll()

						if dll then
							return dll
						end

						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}
		end,
	},

	-- Python debugging
	{
		"mfussenegger/nvim-dap-python",

		ft = "python",

		dependencies = {
			"mfussenegger/nvim-dap",
		},

		enabled = not vim.env.CI,

		config = function()
			local fn = vim.fn
			local python = fn.expand("~/.virtualenvs/debugpy/bin/python")

			if fn.executable(python) == 1 then
				require("dap-python").setup(python)
			else
				vim.notify(
					"debugpy missing:\n"
						.. "python3 -m venv ~/.virtualenvs/debugpy\n"
						.. "~/.virtualenvs/debugpy/bin/pip install debugpy",
					vim.log.levels.WARN
				)
			end
		end,
	},
}
